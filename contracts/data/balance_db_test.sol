import 'data/balance_db.sol';
import 'dapple/test.sol';

contract DSBalanceDB_Test is Test {
    DSBalanceDB db;
    address bob;
    function setUp() {
        db = new DSBalanceDB();
        bob = address(0xbab);
    }
    function testAddBalance() tests("addBalance") {
        var ok = db.addBalance(me, 100);
        assertTrue(ok, "addBalance returned err");
        uint bal; (bal, ok) = db.getBalance(me);
        assertEq(100, bal, "wrong balance after add");
    }
    function testSubBalance() tests("subBalance") {
        var ok = db.addBalance(me, 100);
        ok = db.subBalance(me, 51);
        assertTrue(ok, "subBalance returned err");
        uint bal; (bal, ok) = db.getBalance(me);
        assertEq(49, bal, "wrong balance after sub");
    }
    function testSubBalanceFailsBelowZero() tests("subBalance") {
        bool ok = db.subBalance(me, 100);
        this.assertFalse(ok, "sub failed below zero");
    }
    function testAddBalanceFailsAboveOverflow() tests("addBalance") {
        db.addBalance(bob, 2**256-5);
        var ok = db.addBalance(bob, 4);
        assertTrue(ok);
        ok = db.addBalance(bob, 1);
        assertFalse(ok);
    }
    function testAdminTransfer() {
        bool ok = db.addBalance(bob, 100);
        ok = db.moveBalance(bob, me, 40);
        uint bal; (bal, ok) = db.getBalance(me);
        assertEq(40, bal, "wrong balance");
    }

}
