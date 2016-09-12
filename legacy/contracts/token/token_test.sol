import 'auth.sol';
import 'dapple/test.sol';
import 'dapple/debug.sol';
import 'token/base.sol';
import 'factory/factory.sol';
import 'factory/factory_test.sol';

// Supporting classes

contract DSTokenTester is Tester, Debug {
    function doTransferFrom(address from, address to, uint amount)
        returns (bool)
    {
        logs("in doTransferFrom");
        return DSToken(_t).transferFrom(from, to, amount);
    }

    function doTransfer(address to, uint amount)
        returns (bool)
    {
        return DSToken(_t).transfer(to, amount);
    }

    function doApprove(address recipient, uint amount)
        returns (bool)
    {
        return DSToken(_t).approve(recipient, amount);
    }

    function doAllowance(address owner, address spender)
        constant returns (uint)
    {
        return DSToken(_t).allowance(owner, spender);
    }

    function doBalanceOf(address who) constant returns (uint) {
        return DSToken(_t).balanceOf(who);
    }
}

// Tests that should work for all Tokens
contract DSTokenTest is Test, DSAuthUser {
    uint constant initialBalance = 1000;

    DSToken token;
    DSTokenTester user1;
    DSTokenTester user2;

    function DSTokenTest() {
        token = createToken();
        user1 = new DSTokenTester();
        user2 = new DSTokenTester();
        user1._target(address(token));
        user2._target(address(token));
    }

    function createToken() internal returns (DSToken) {
        return new DSTokenBase(initialBalance);
    }

    function testSetupPrecondition() {
        assertEq(token.balanceOf(this), initialBalance);
    }

    function testTransferCost() logs_gas() {
        token.transfer(address(0), 10);
    }

    function testAllowanceStartsAtZero() logs_gas {
        assertEq(token.allowance(user1, user2), 0);
    }

    function testValidTransfers() logs_gas {
        uint sentAmount = 250;
        log_named_address("token11111", token);
        token.transfer(user2, sentAmount);
        assertEq(token.balanceOf(user2), sentAmount);
        assertEq(token.balanceOf(me), initialBalance - sentAmount);
    }

    function testFailWrongAccountTransfers() logs_gas {
        uint sentAmount = 250;
        token.transferFrom(user2, me, sentAmount);
    }

    function testFailInsufficientFundsTransfers() logs_gas {
        uint sentAmount = 250;
        token.transfer(user1, initialBalance - sentAmount);
        token.transfer(user2, sentAmount+1);
    }

    function testApproveReturnTrueOnSuccess() {
        assertTrue( token.approve(user1, 100) );
    }

    function testApproveSetsAllowance() logs_gas {
        log_named_address("Test", this);
        log_named_address("Token", token);
        log_named_address("Me", me);
        log_named_address("User 2", user2);
        token.approve(user2, 25);
        assertEq(token.allowance(me, user2), 25,
                 "wrong allowance");
    }

    function testChargesAmountApproved() logs_gas {
        uint amountApproved = 20;
        token.approve(user2, amountApproved);
        assertTrue(user2.doTransferFrom(
            me, user2, amountApproved),
            "couldn't transferFrom");
        assertEq(token.balanceOf(me), initialBalance - amountApproved,
                 "wrong balance after transferFrom");
    }

    function testFailTransferWithoutApproval() logs_gas {
        address self = this;
        token.transfer(user1, 50);
        token.transferFrom(user1, self, 1);
    }

    function testFailChargeMoreThanApproved() logs_gas {
        address self = this;
        token.transfer(user1, 50);
        user1.doApprove(self, 20);
        token.transferFrom(user1, self, 21);
    }
}

