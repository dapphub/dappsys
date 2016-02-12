import 'dapple/test.sol';
import 'token/eth_wrapper.sol';
import 'token/token.sol';
import 'token/token_test.sol';


contract DSEthTokenTest is DSTokenTest, DSEthTokenEvents {
    function createToken() internal returns (DSToken) {
        return new DSEthToken();
    }
    function setUp() {
        token.call.value(initialBalance)(); // TokenTest precondition
    }

    function testDeposit() {
        expectEventsExact(token);
        Deposit(this, 10);

        token.call.value(10)("deposit");
        assertEq(token.balanceOf(this), initialBalance + 10);
    }

    function testWithdraw() {
        expectEventsExact(token);
        Deposit(this, 10);
        Withdrawal(this, 5);

        var startingBalance = this.balance;
        token.call.value(10)("deposit");
        assertTrue(DSEthToken(token).withdraw(5));
        assertEq(this.balance, startingBalance - 5);
    }
}
