import 'data/balance_db.sol';
import 'dapple/test.sol';

contract DSBalanceDB_Test is Test {
    DSBalanceDB db;
    address bob;
    function setUp() {
        db = new DSBalanceDB();
        bob = address(0xbab);
    }
    function testAddBalance() tests("add_balance") {
        var ok = db.add_balance(me, 100);
        assertTrue(ok, "add_balance returned err");
        uint bal; (bal, ok) = db.get_balance(me);
        assertEq(100, bal, "wrong balance after add");
    }
    function testSubBalance() tests("sub_balance") {
        var ok = db.add_balance(me, 100);
        ok = db.sub_balance(me, 51);
        assertTrue(ok, "sub_balance returned err");
        uint bal; (bal, ok) = db.get_balance(me);
        assertEq(49, bal, "wrong balance after sub");
    }
    function testSubBalanceFailsBelowZero() tests("sub_balance") {
        bool ok = db.sub_balance(me, 100);
//        assertTrue(ok, "sub failed below zero");
//        db.add_balance(me, 50);
 //       ok = db.sub_balance(me, 51);
        this.assertFalse(ok, "sub failed below zero");
    }

    function testAdminTransfer() {
        bool ok = db.add_balance(bob, 100);
        ok = db.move_balance(bob, me, 40);
        uint bal; (bal, ok) = db.get_balance(me);
        assertEq(40, bal, "wrong balance");
    }

}
