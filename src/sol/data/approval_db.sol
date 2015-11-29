import 'auth/auth.sol';

// Spending approval for standard token pattern
contract DSApprovalDB is DSAuth {
    mapping(address => mapping( address=>uint)) approvals;
    function set( address holder, address spender, uint amount )
             auth()
             returns (bool ok)
    {
        approvals[holder][spender] = amount;
        return true;
    }
    function add( address holder, address spender, uint amount )
             auth()
             returns (uint allowance, bool ok)
    {
        var old_amount = approvals[holder][spender];
        var new_amount = old_amount + amount;
        approvals[holder][spender] = new_amount;
        return (new_amount, true);
    }
    function get( address holder, address spender )
             returns (uint amount, bool ok )
    {
        return (approvals[holder][spender], true);
    }
}
