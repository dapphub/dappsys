import 'actor/base.sol';
contract DSMultisigActor is DSBaseActor
{
    mapping( uint => action )      actions;
    mapping( address => bool)      is_member;
    multisig_config                config;
    uint                           next_action;

    mapping( address => mapping( uint => bool ) ) approvals;

    function DSMultisigActor() {
        this.updateMember( msg.sender, true );
        this.updateRequiredSignatures( 1 );
        this.updateDefaultDuration( 7 days );
    }

    struct multisig_config {
        uint required_signatures;
        uint num_members;
        uint default_duration; // How long until it expires
    }

    struct action {
        address target;
        bytes calldata;
        uint value;
        uint gas;

        uint approvals;
        uint expiration;

        bool succeeded;
        bool completed;
    }

    // Simple way to require multisig approval to self-modify.
    // Attach to external functions.
    modifier self_only() {
        if( msg.sender == address(this) ) {
            _
        }
    }
    function updateRequiredSignatures( uint number )
             external
             self_only()
             returns (bool)
    {
        config.required_signatures = number;
    }
    function updateMember( address who, bool member )
             external
             self_only()
             returns (bool)
    {
        if( member ) {
            if( !is_member[who] ) {
                is_member[who] = member;
                config.num_members++;
            }
        } else {
            if( is_member[who] ) {
                is_member[who] = member;
                config.num_members--;
            }
        }
        return true;
    }
    function updateDefaultDuration( uint duration )
             external
             self_only()
             returns (bool)
    {
        config.default_duration = duration;
        return true;
    }

    modifier members_only() {
        if( is_member[msg.sender] ) {
            _
        }
    } 
    // Propose an action.
    function propose( address target, bytes calldata, uint value, uint gas )
             members_only()
             returns (uint call_id)
    {
        action memory a;
        a.target = target;
        a.value = value;
        a.calldata = calldata;
        a.gas = gas;
        a.expiration = block.timestamp + config.default_duration;
        next_action++; // increment first because 0 is not a valid call_id
        actions[next_action] = a;
        return next_action;
    }

    // Confirms the action and executes it if there were enough confirmations.
    function confirm( uint call_id )
             members_only()
             returns (bool confirmed, bool executed, bool call_ret)
    {
        if( !approvals[msg.sender][call_id] ) {
            approvals[msg.sender][call_id] = true;
            actions[call_id].approvals++;
            confirmed = true;
            (executed, call_ret) = trigger( call_id );
        }
    }
    function revoke( uint call_id ) 
             members_only()
             returns (bool revoked)
    {
        if( approvals[msg.sender][call_id] ) {
            approvals[msg.sender][call_id] = false;
            actions[call_id].approvals--;
            return true;
        }
        return false;
    }
    // When you remove a member, their votes are still active.
    // Individual votes for non-members can be removed by anyone.
    function clearVote( uint call_id, address who ) returns (bool removed) {
        if( !is_member[who] ) {
            if( approvals[who][call_id] ) {
                approvals[who][call_id] = false;
                actions[call_id].approvals--;
                return true;
            }
        }
    }
    // Exposed separately because if required_sigantures drops below
    // the number of confirmations, anyone can trigger the action.
    function trigger( uint call_id ) returns (bool executed, bool call_ret) {
        var action = actions[call_id];
        if( block.timestamp > action.expiration ) {
            return (false, false);
        }
        if( action.approvals > config.required_signatures ) {
            call_ret = exec( action.target, action.calldata, action.value, action.gas );
            executed = true;
            action.completed = true;
        }
    }
}
