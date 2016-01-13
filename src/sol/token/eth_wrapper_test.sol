import 'dapple/test.sol';
import 'token/eth_wrapper.sol';
import 'token/token_test.sol';


contract EthTokenTest is Test {
    TokenTester tt;
    EthToken eth;
    Tester Bob;
    function setUp() {
        tt = new TokenTester();
        eth = new EthToken();
        Bob = new Tester();
        // check precondition
        assertTrue( eth.deposit.value(100)() );
    }
    function testDepositWithdraw() {
    }
}
