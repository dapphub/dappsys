import 'dapple/test.sol';
import 'token/eth_wrapper.sol';
import 'token/token_test.sol';


contract EthTokenTest is TokenTest {
    EthToken eth;
    Tester Bob;
    function setUp() {
        eth = new EthToken();
        Bob = new Tester();
        // check precondition
        //assertTrue( eth.deposit.value(100)() );
    }
    function testDepositWithdraw() {
    }
}
