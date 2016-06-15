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

    function testWithdrawAttackRegression() {
        var attacker = new ReentrantWithdrawalAttack(DSEthToken(token));
        attacker.send(100);
        attacker.attack();
        assertEq(attacker.balance, 0);
        assertEq(token.balanceOf(attacker), 100);
    }
    function testWithdrawAttack2Regression() {
        var attacker = new ReentrantWithdrawalAttack2(DSEthToken(token));
        attacker.send(100);
        attacker.attack();
        assertEq(attacker.balance, 0);
        assertEq(token.balanceOf(attacker), 100);
    }
}

contract ReentrantWithdrawalAttack {
    DSEthToken _token;
    address _owner;
    uint _bal;

    function ReentrantWithdrawalAttack(DSEthToken token) {
        _owner = msg.sender;
        _token = token;
    }

    function attack() {
        _bal = this.balance;
        _token.deposit.value(_bal)();
        _token.withdraw(_bal);
    }

    function() {
        if (msg.sender == _owner) return;
        _token.withdraw(_bal);
    }
}

// throws on 2nd entry
contract ReentrantWithdrawalAttack2 {
    DSEthToken _token;
    address _owner;
    uint _bal;
    bool _entered;

    function ReentrantWithdrawalAttack2(DSEthToken token) {
        _owner = msg.sender;
        _token = token;
    }

    function attack() {
        _bal = this.balance;
        _token.deposit.value(_bal)();
        _token.withdraw(_bal);
    }

    function() {
        if (msg.sender == _owner) return;
        _entered = true;
        if (_entered) throw;
        _token.withdraw(_bal);
    }
}
