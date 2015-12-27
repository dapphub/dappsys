import 'actor/base.sol';
contract DSMultisigActor is DSBaseActor
{
    function DSMultisigActor() {
        this.updateMember( msg.sender, true );
        this.updateRequiredSignatures( 1 );
    }

    struct multisig_config {
        uint required_signatures;
        uint num_members;
    }
    struct action {
        address target;
        bytes calldata;
        uint value;
        uint gas;

        uint approvals;
        uint required;

        bool succeeded;
        bool completed;
    }

    mapping( uint => action )      actions;
    mapping( address => bool)      is_member;
    multisig_config                config;
    uint                           next_action;

    mapping( address => mapping( uint => bool ) ) approvals;

    function updateRequiredSignatures( uint number )
             external
             returns (bool)
    {
        if( msg.sender == address(this) ) {
            config.required_signatures = number;
        }
    }
    function updateMember( address who, bool member )
             external
             returns (bool)
    {
        // Can only update via a multisig action.
        if( msg.sender == address(this) ) {
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
        return false;
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
        // 0 is never a reasonable gas amount, so it's a magic value for "all the gas"
        a.gas = gas;
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
        if( action.approvals > config.required_signatures ) {
            call_ret = exec( action.target, action.calldata, action.value, action.gas );
            executed = true;
            action.completed = true;
        }
    }
}
