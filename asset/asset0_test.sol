import 'dapple/test.sol';
import 'asset/asset0.sol';
//import 'util/false.sol';

contract helper {
    function do_transfer( DSAsset0 a, address to, uint amount ) returns (bool) {
        return a.transfer(to, amount);
    }
}

contract DSAsset0Test is Test {
    DSAsset0 A;
    helper h;
    address bob;
    function setUp() {
        A = new DSAsset0Impl();
        h = new helper();
        bob = address(0x1);
        //assertTrue( A.get_balance(me) == (uint(10**(6+18)), true) );
        var (bal, ok) = A.get_balance(me);
        assertTrue( ok );
        assertTrue( bal == uint(10**(6+18)) );
    }
    function testOnlyOwnerCanTransfer() {
        this.assertFalse( h.do_transfer(A, address(h), 100) );
        var (bal, ok) = A.get_balance(address(h));
        assertEq( bal, 0 );
    }
//    function testCanUpdateDB() {
//        var new_db = new DSBalanceDB();
//        var auth = DSAuthority(new False());
//    }
}
