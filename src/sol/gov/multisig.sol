import 'actor/base.sol';
contract DSMultisigActor is DSBaseActor
{
    mapping( uint => action )  public    actions;
    mapping( address => bool)  public    is_member;
    multisig_config            public    config;
    uint                       public    next_action;

    mapping( address => mapping( uint => bool ) ) approvals;

    event MemberUpdate( address who, bool what );
    event Proposal( address target, bytes calldata, uint value, uint gas, uint call_id );
    event ConfirmationUpdate( uint call_id, address who, bool what );
    event ActionTrigger( uint call_id, bool call_success );
    event ConfigUpdate( uint required, uint expiration_duration, uint delay_duration );

    function DSMultisigActor() {
        this.updateMember( msg.sender, true );
        this.updateConfig( 1, 3 days, 0 ); // 1 sig, 3 day expiry, no action delay
    }

    struct multisig_config {
        uint required_signatures;
        uint expiration_duration; // How long until it expires
        uint delay_duration;
    }

    struct action {
        address target;
        bytes calldata;
        uint value;
        uint gas;

        uint approvals;
        uint expiration; // The last confirmation has to happen before this time.
        uint action_time; // The action has been approved and can be executed at this time.

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
    function updateConfig( uint required_signatures
                         , uint expiration_duration
                         , uint delay_duration )
             external
             self_only()
             returns (bool)
    {
        config.required_signatures = required_signatures;
        config.expiration_duration = expiration_duration;
        config.delay_duration = delay_duration;
        ConfigUpdate( required_signatures, expiration_duration, delay_duration );
        return true;
    }
    function updateMember( address who, bool what )
             external
             self_only()
             returns (bool)
    {
        if( what ) {
            if( !is_member[who] ) {
                is_member[who] = what;
            }
        } else {
            if( is_member[who] ) {
                is_member[who] = what;
            }
        }
        MemberUpdate( who, what );
        return true;
    }

    modifier members_only() {
        if( is_member[msg.sender] ) {
            _
        }
    } 
    // Propose an action.
    // Warning! Don't forget 0 gas means "all the gas"!
    function propose( address target, bytes calldata, uint value, uint gas )
             members_only()
             returns (uint call_id)
    {
        action memory a;
        a.target = target;
        a.value = value;
        a.calldata = calldata;
        a.gas = gas;
        a.expiration = block.timestamp + config.expiration_duration;
        next_action++; // increment first because 0 is not a valid call_id
        actions[next_action] = a;
        Proposal( target, calldata, value, gas, next_action );
        return next_action;
    }

    // Confirms the action and executes it if there were enough confirmations.
    function confirm( uint call_id )
             members_only()
             returns (bool confirmed, bool executed, bool call_ret)
    {
        var action = actions[call_id];
        if( action.completed ) {
            return (false, false, false);
        }
        if( block.timestamp > action.expiration ) {
            return (false, false, false);
        }
        if( !approvals[msg.sender][call_id] ) {
            approvals[msg.sender][call_id] = true;
            action.approvals++;
            confirmed = true;
            ConfirmationUpdate( call_id, msg.sender, true );
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
            ConfirmationUpdate( call_id, msg.sender, false );
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
                ConfirmationUpdate( call_id, who, false );
                return true;
            }
        }
    }
    // Exposed publicly because if required_sigantures drops below
    // the number of confirmations, anyone can trigger the action.
    // This is also how to activate the delay period in that case.
    function trigger( uint call_id ) returns (bool executed, bool call_ret) {
        var action = actions[call_id];
        if( action.completed ) {
            return (false, false);
        }
        if( action.approvals > config.required_signatures ) {
            if( action.action_time == 0 ) {
                action.action_time = block.timestamp + config.delay_duration;
            }
            if( block.timestamp >= action.action_time ) {
                call_ret = exec( action.target, action.calldata, action.value, action.gas );
                executed = true;
                action.completed = true;
                ActionTrigger( call_id, call_ret );
            }
        }
    }
}
