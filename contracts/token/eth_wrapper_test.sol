import 'dapple/test.sol';
import 'token/eth_wrapper.sol';
import 'token/token_test.sol';


contract EthTokenTest is TokenTest {
    function setUp() {
        t = new DSEthToken();
    }
    function testDepositWithdraw() {
    }
}
