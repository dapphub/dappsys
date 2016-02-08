import 'dapple/test.sol';
import 'dapple/debug.sol';
import 'token/base.sol';

contract BaseTokenTester is Tester {
    function doTransferFrom(address from, address to, uint amount)
        returns (bool)
    {
        return DSTokenBase(_t).transferFrom(from, to, amount);
    }

    function doTransfer(address to, uint amount)
        returns (bool)
    {
        return DSTokenBase(_t).transfer(to, amount);
    }

    function doApprove(address recipient, uint amount)
        returns (bool)
    {
        return DSTokenBase(_t).approve(recipient, amount);
    }

    function doAllowance(address owner, address spender)
        constant returns (uint)
    {
        return DSTokenBase(_t).allowance(owner, spender);
    }

    function doBalanceOf(address who) constant returns (uint) {
        return DSTokenBase(_t).balanceOf(who);
    }
}

contract BaseTokenTest is Test {
    uint constant issuedAmount = 1000;

    DSTokenBase Token;
    BaseTokenTester User1;
    BaseTokenTester User2;
    address user1;
    address user2;

    function BaseTokenTest() {
        Token = new DSTokenBase(issuedAmount);
    }

    function setUp() {
        User1 = new BaseTokenTester();
        User2 = new BaseTokenTester();
        User1._target(address(Token));
        User2._target(address(Token));
        user1 = address(User1);
        user2 = address(User2);

        Token.transfer(user1, issuedAmount);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(User1.doAllowance(user1, user2), 0);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        User1.doTransfer(user2, sentAmount);
        assertEq(User2.doBalanceOf(user2), sentAmount);
        assertEq(User1.doBalanceOf(user1), issuedAmount - sentAmount);
    }

    function testFailWrongAccountTransfers() logs_gas {
        uint sentAmount = 250;
        User1.doTransferFrom(user2, user1, sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        uint sentAmount = 250;
        Token.transfer(user1, issuedAmount);
        User1.doTransfer(user2, issuedAmount+1);
    }

    function testApproveSetsAllowance() logs_gas {
        User1.doApprove(user2, 25);
        assertEq(User1.doAllowance(user1, user2), 25, "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        uint amountApproved = 20;
        User1.doApprove(user2, amountApproved);
        assertTrue(User2.doTransferFrom(user1, user2, amountApproved),
                   "couldn't transferFrom");
        assertEq(User1.doBalanceOf(user1), issuedAmount - amountApproved,
                 "wrong balance after transferFrom");
    }

    function testFailTransferWithoutApproval() logs_gas {
        address self = address(this);
        Token.transfer(user1, 50);
        Token.transferFrom(user1, self, 1);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        address self = address(this);
        Token.transfer(user1, 50);
        User1.doApprove(self, 20);
        Token.transferFrom(user1, self, 21);
    }

    function runTest( DSToken t ) constant returns (bool success) {
        // TODO move to Test definition
/*

        DSToken(bob).approve(self, 0);
        assertEq( t.allowance(bob, self), 0, "wrong allowance" );

        //assertFalse( t.transferFrom(bob, self, 1), "transferFrom without permission" );
        //assertEq( t.balanceOf(bob), 30, "wrong balance after transferFrom" );

        DSToken(bob).approve(self, 5);
        assertTrue( t.transferFrom(bob, self, 5) );
        assertEq( t.balanceOf(bob), 25 );
*/

        //assertFalse( t.transferFrom(bob, self, 1) );
        //assertEq( t.balanceOf(bob), 25 );
        //assertEq( t.balanceOf(self), 75 );
        return !failed;
    }
}
