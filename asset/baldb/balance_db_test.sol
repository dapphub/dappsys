import 'dappsys/test/test.sol';
import 'dappsys/asset/baldb/balance_db.sol';

contract DSBalanceDB_Test is Test {
    DSBalanceDB db;
    function setUp() {
        db = new DSBalanceDB();
    }
    function testAddBalance() tests("add_balance") {
        var ok = db.add_balance(me, 100);
        assertTrue(ok, "add_balance returned err");
        assertEq(100, db.balances(me), "wrong balance after add");
    }
    function testSubBalance() tests("sub_balance") {
        var ok = db.add_balance(me, 100);
        ok = db.sub_balance(me, 51);
        assertTrue(ok, "sub_balance returned err");
        assertEq(49, db.balances(me), "wrong balance after sub");
    }
    function testSubBalanceFailsBelowZero() tests("sub_balance") {
        bool ok = db.sub_balance(me, 100);
//        assertTrue(ok, "sub failed below zero");
//        db.add_balance(me, 50);
 //       ok = db.sub_balance(me, 51);
        assertFalse(ok, "sub failed below zero");
    }
}
