import 'dapple/test.sol';
import 'data/approval_db.sol';

contract DSApprovalDB_Test is Test {
    DSApprovalDB db;
    address bob;
    function setUp() {
        db = new DSApprovalDB();
        bob = address(bytes32("bob"));
    }
    function testSetGet() {
        assertTrue( db.set(me, bob, 100) );
        var (bal, ok) = db.get(me, bob);
        assertTrue(ok);
        assertEq( 100, bal );
    }
}
