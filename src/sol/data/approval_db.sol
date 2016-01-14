import 'auth/auth.sol';

// Spending approval for standard token pattern (see `token/EIP20.sol`)
contract DSApprovalDB is DSAuth {
    mapping(address => mapping( address=>uint)) approvals;
    function set( address holder, address spender, uint amount )
             auth()
             returns (bool ok)
    {
        approvals[holder][spender] = amount;
        return true;
    }
    function get( address holder, address spender )
             returns (uint amount, bool ok )
    {
        return (approvals[holder][spender], true);
    }
}

contract DSApprovalDBFactory {
    function build() returns (DSApprovalDB) {
        var db = new DSApprovalDB();
        db.updateAuthority(msg.sender, false);
        return db;
    }
}
