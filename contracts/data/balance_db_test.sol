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
        db.addBalance(me, 100);
        var bal = db.getBalance(me);
        assertEq(100, bal, "wrong balance after add");
    }
    function testSubBalance() tests("subBalance") {
        db.addBalance(me, 100);
        db.subBalance(me, 51);
        var bal = db.getBalance(me);
        assertEq(49, bal, "wrong balance after sub");
    }
    function testFailSubBalanceBelowZero() tests("subBalance") {
        db.subBalance(me, 100);
    }
    function testFailAddBalanceAboveOverflow() tests("addBalance") {
        db.addBalance(bob, 2**256-5);
        db.addBalance(bob, 4);
        db.addBalance(bob, 1);
    }
    function testAdminTransfer() {
        db.addBalance(bob, 100);
        db.moveBalance(bob, me, 40);
        var bal = db.getBalance(me);
        assertEq(40, bal, "wrong balance");
    }
}
