import 'dapple/test.sol';
import 'token/eth_wrapper.sol';
import 'token/token_test.sol';


contract EthTokenTest is TokenTest {
    uint constant initialBalance = 100;

    function setUp() {
        t = new DSEthToken();
        t.call.value(initialBalance)(); // TokenTest precondition
    }

    function testDeposit() {
        t.call.value(10)("deposit");
        assertEq(t.balanceOf(this), initialBalance + 10);
    }

    function testWithdraw() {
        var startingBalance = this.balance;
        t.call.value(10)("deposit");
        assertTrue(DSEthToken(t).withdraw(5));
        assertEq(this.balance, startingBalance - 5);
    }
}
