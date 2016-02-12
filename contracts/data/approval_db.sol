import 'auth.sol';

contract DSApprovalDBEvents {
    event Approval( address indexed owner, address indexed spender, uint value );
}

// Spending approval for standard token pattern (see `token/EIP20.sol`)
contract DSApprovalDB is DSAuth, DSApprovalDBEvents {
    mapping(address => mapping( address=>uint)) _approvals;

    function setApproval( address holder, address spender, uint amount )
             auth()
    {
        _approvals[holder][spender] = amount;
        Approval( holder, spender, amount );
    }
    function getApproval( address holder, address spender )
             returns (uint amount )
    {
        return _approvals[holder][spender];
    }
}
