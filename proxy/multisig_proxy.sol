

contract DSMultisigProxy {
    struct multisig_config {
        uint required_signatures;
        uint num_members;
    }
    struct action {
        address target;
        bytes calldata;
        uint approvals;
        bool acted;
    }

    mapping( address => bool)     public    is_member;
    multisig_config               public    config;
    action[2**128]                public    actions;
    uint                          public    next_action;

    mapping( address => mapping( uint => bool ) ) approvals;
    
    function prime( address target, bytes calldata )
             returns (uint action_id)
    {
        action a;
        a.target = target;
        a.calldata = calldata;
        a.approvals = 0;
        a.acted = false;

        actions[next_action] = a;
        approve(next_action);
        next_action++;
    }
    function approve( uint action_id )
    {
        if( is_member[msg.sender] && !approvals[msg.sender][action_id] ) {
            actions[action_id].approvals++;
        }
        act( action_id );
    }
    function act( uint action ) {
        if( 
    }
}
