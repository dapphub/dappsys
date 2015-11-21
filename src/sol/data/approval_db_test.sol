import 'dapple/test.sol';

contract DSApprovalDB_Test is Test {
    DSApprovalDB db;
    address bob;
    function setUp() {
        db = new DSApprovalDB();
        bob = address(bytes32("bob"));
    }
    function testEverything() {
        assertTrue( db.set(me, bob, 100) );
        var (bal, ok) = db.get(me, bob);
        assertTrue(ok);
        assertEq( 100, bal );
        assertTrue( db.add( me, bob, 50) );
        (bal, ok) = db.get(me, bob);
        assertTrue(ok);
        assertEq( 150, bal );
    }
}
