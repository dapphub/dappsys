import 'data/balance_db.sol';
import 'dapple/test.sol';

contract DSBalanceDB_Test is DSBalanceDBEvents, Test {
    DSBalanceDB db;
    address bob;
    function setUp() {
        db = new DSBalanceDB();
        bob = address(0xbab);
    }
    function testAddBalance() tests("addBalance") {
        expectEventsExact(db);
        BalanceUpdate(me, 100);

        db.addBalance(me, 100);
        var bal = db.getBalance(me);
        assertEq(100, bal, "wrong balance after add");
    }
    function testSubBalance() tests("subBalance") {
        expectEventsExact(db);
        BalanceUpdate(me, 100);
        BalanceUpdate(me, 49);

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
    function testMoveBalance() {
        expectEventsExact(db);
        BalanceUpdate(bob, 100);
        BalanceUpdate(bob, 60);
        BalanceUpdate(me, 40);

        db.addBalance(bob, 100);
        db.moveBalance(bob, me, 40);
        assertEq(40, db.getBalance(me), "wrong recipient balance");
        assertEq(60, db.getBalance(bob), "wrong sender balance");
    }
    function testFailMoveBalanceDueToInsufficientFunds() {
        db.addBalance(bob, 10);
        db.moveBalance(bob, me, 40);
    }
    function testSetBalanceSetsSupply() {
        expectEventsExact(db);
        BalanceUpdate(bob, 100);

        db.setBalance(bob, 100);
        assertEq(db.getSupply(), 100);
    }
    function testSetBalanceSetsSupplyCumulatively() {
        expectEventsExact(db);
        BalanceUpdate(bob, 100);
        BalanceUpdate(me, 200);

        db.setBalance(bob, 100);
        db.setBalance(me, 200);
        assertEq(db.getSupply(), 300);
    }
    function testSetBalanceUpdatesSupply() {
        expectEventsExact(db);
        BalanceUpdate(bob, 100);
        BalanceUpdate(bob, 50);

        db.setBalance(bob, 100);
        db.setBalance(bob, 50);
        assertEq(db.getSupply(), 50);
    }
}
