import 'auth/auth.sol';

// Spending approval for standard token pattern (see `token/EIP20.sol`)
contract DSApprovalDB is DSAuth {
    mapping(address => mapping( address=>uint)) _approvals;
    event Approval( address indexed owner, address indexed spender, uint value );

    function set( address holder, address spender, uint amount )
             auth()
    {
        _approvals[holder][spender] = amount;
        Approval( holder, spender, amount );
    }
    function get( address holder, address spender )
             returns (uint amount )
    {
        return _approvals[holder][spender];
    }
}
