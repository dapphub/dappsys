import 'dapple/test.sol';
import 'token/erc20.sol';
import 'token/base.sol';


contract BaseTokenTest is Test {
    DSToken t;
    Tester Bob;
    address bob;
    address self;
    function setUp() {
        t = new DSTokenBase( 100 );
        Bob = new Tester();
        bob = address(Bob);
        self = address(this);
    }
    function testBasics() {
        t.transfer( bob, 50 );
        assertEq( t.balanceOf(bob), 50 );
        assertEq( t.balanceOf(self), 50 );
        assertEq( t.totalSupply(), 100 );

        Bob._target(address(t));
        DSToken(bob).approve(self, 25);
        assertEq( t.allowance(bob, self), 25, "wrong allowance" );
     
        assertTrue( t.transferFrom(bob, self, 20), "couldn't transferFrom" );
        assertEq( t.balanceOf(bob), 30, "wrong balance after transferFrom" );
        
        DSToken(bob).approve(self, 0);
        assertEq( t.allowance(bob, self), 0, "wrong allowance" );

        assertFalse( t.transferFrom(bob, self, 1), "transferFrom without permission" );
        assertEq( t.balanceOf(bob), 30, "wrong balance after transferFrom" );

        DSToken(bob).approve(self, 5);
        assertTrue( t.transferFrom(bob, self, 5) );
        assertEq( t.balanceOf(bob), 25 );
        
        assertFalse( t.transferFrom(bob, self, 1) );
        assertEq( t.balanceOf(bob), 25 );
        assertEq( t.balanceOf(self), 75 );
    }
}
