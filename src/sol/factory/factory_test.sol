import 'factory/factory.sol';
import 'dapple/test.sol';

contract Factory1Test is Test {
    DSFactory f;
    function setUp() {
        f = new DSFactory1();
    }
    function testCreateCostMain() logs_gas() {
        f = new DSFactory1();
    }
}
