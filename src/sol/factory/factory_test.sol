import 'factory/factory.sol';
import 'dapple/test.sol';

contract Factory1Test is Test {
    DSFactory f;
    DSFactory1Helper1 h1;
    function setUp() {
        h1 = new DSFactory1Helper1();
        f = new DSFactory1(h1);
    }
    function testCreateCostH1() logs_gas() {
        h1 = new DSFactory1Helper1();
    }
    function testCreateCostMain() logs_gas() {
        f = new DSFactory1(h1);
    }
}
