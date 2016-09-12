import 'dapple/test.sol';
import 'data/approval_db.sol';

contract DSApprovalDB_Test is Test, DSApprovalDBEvents {
    DSApprovalDB db;
    address bob;
    function setUp() {
        db = new DSApprovalDB();
        bob = address(bytes32("bob"));
    }
    function testSetGet() {
        expectEventsExact(db);
        Approval(me, bob, 100);

        db.setApproval(me, bob, 100);
        var bal = db.getApproval(me, bob);
        assertEq( 100, bal );
    }
}
