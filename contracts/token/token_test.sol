import 'dapple/test.sol';
import 'token/erc20.sol';
import 'token/base.sol';

// Rough rewrite of old Test contract into generic tester
// for which you can override setUp.
contract TokenTest is Test {
    DSToken t;
    Tester Alice; address alice;
    Tester Bob; address bob;
    address self;
    function TokenTest() {
        Alice = new Tester();
        alice = address(Alice);
        Bob = new Tester();
        bob = address(Bob);
        self = address(this);
    }
    function setUp() {
        t = new DSTokenBase(100);
    }
    function testSetupPrecondition() {
        assertEq( t.balanceOf(self), 100 );
    }
    function testTransferBasics() {
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

        DSToken(bob).approve(self, 5);
        assertTrue( t.transferFrom(bob, self, 5) );
        assertEq( t.balanceOf(bob), 25 );

    }
    function testFailTransferFromWithoutPermission() {
        t.transfer( bob, 50 );

        Bob._target(address(t));
        DSToken(bob).approve(self, 25);
        DSToken(bob).approve(self, 0);

        assertEq( t.allowance(bob, self), 0, "wrong allowance" );

        t.transferFrom(bob, self, 1); // throw!
    }
}
