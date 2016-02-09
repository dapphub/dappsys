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
    BaseTokenTester user1;
    BaseTokenTester user2;
    address userAddress1;
    address userAddress2;

    function BaseTokenTest() {
        Token = new DSTokenBase(issuedAmount);
    }

    function setUp() {
        user1 = new BaseTokenTester();
        user2 = new BaseTokenTester();
        user1._target(address(Token));
        user2._target(address(Token));
        userAddress1 = address(user1);
        userAddress2 = address(user2);

        Token.transfer(userAddress1, issuedAmount);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(user1.doAllowance(userAddress1, userAddress2), 0);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        user1.doTransfer(userAddress2, sentAmount);
        assertEq(user2.doBalanceOf(userAddress2), sentAmount);
        assertEq(user1.doBalanceOf(userAddress1), issuedAmount - sentAmount);
    }

    function testFailWrongAccountTransfers() logs_gas {
        uint sentAmount = 250;
        user1.doTransferFrom(userAddress2, userAddress1, sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        uint sentAmount = 250;
        Token.transfer(userAddress1, issuedAmount);
        user1.doTransfer(userAddress2, issuedAmount+1);
    }

    function testApproveSetsAllowance() logs_gas {
        user1.doApprove(userAddress2, 25);
        assertEq(user1.doAllowance(userAddress1, userAddress2), 25,
                 "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        uint amountApproved = 20;
        user1.doApprove(userAddress2, amountApproved);
        assertTrue(user2.doTransferFrom(
            userAddress1, userAddress2, amountApproved),
            "couldn't transferFrom");
        assertEq(user1.doBalanceOf(userAddress1), issuedAmount - amountApproved,
                 "wrong balance after transferFrom");
    }

    function testFailTransferWithoutApproval() logs_gas {
        address self = address(this);
        Token.transfer(userAddress1, 50);
        Token.transferFrom(userAddress1, self, 1);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        address self = address(this);
        Token.transfer(userAddress1, 50);
        user1.doApprove(self, 20);
        Token.transferFrom(userAddress1, self, 21);
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
