contract DSMultisigProxy is DSBaseProxy {
    struct multisig_config {
        uint required_signatures;
        uint num_members;
    }
    struct action {
        address target;
        uint value;
        bytes calldata;

        uint approvals;
        uint required;

        bool succeeded;
        bool complete;
    }

    mapping( uint => action )     public    actions;
    mapping( address => bool)     public    is_member;
    multisig_config               public    config;
    uint                          public    next_action;

    mapping( address => mapping( uint => bool ) ) approvals;
    
    function execute( address target, uint value, bytes calldata )
             returns (uint call_id, bool ok)
    {
        action memory a;
        a.target = target;
        a.value = value;
        a.calldata = calldata;

        actions[next_action] = a;
        next_action++;
    }
    function confirm( uint call_id )
             returns (bool executed, bool call_ret, bool ok)
    {
        if( is_member[msg.sender] && !approvals[msg.sender][call_id] ) {
            actions[call_id].approvals++;
        }
    }
    function confirm( uint call_id )
             returns (bool executed, bool call_ret, bool ok)
    {
        if( is_member[msg.sender] && !approvals[msg.sender][call_id] ) {
            actions[call_id].approvals++;
        }
    }

}
