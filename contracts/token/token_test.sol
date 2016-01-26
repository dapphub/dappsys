import 'dapple/test.sol';
import 'token/erc20.sol';
import 'token/base.sol';

// Rough rewrite of old Test contract into generic tester
// which must be invoked by actual `test` functions
// Doing this in a cleaner way is part of
// https://github.com/NexusDevelopment/dapple/issues/63
contract TokenTester is Test {
    function runTest( DSToken t ) constant returns (bool success) {
        // TODO move to Test definition
        var Alice = new Tester();
        var alice = address(Alice);
        var Bob = new Tester();
        var bob = address(Bob);
        var self = address(this);

        assertEq( t.balanceOf(self), 100, "test precondition");

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
        return !failed;
    }
}

contract BaseTokenTest is Test {
    function setUp() {
    }
    function testBaseToken() {
        var tester = new TokenTester();
        DSToken t = new DSTokenBase(100);
        // Satisfy test precondition
        t.transfer( address(tester), 100 );
        assertTrue( tester.runTest( t ) );
    }
}
