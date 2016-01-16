import 'factory/factory.sol';
import 'dapple/test.sol';

contract FactoryTest is Test {
    DSFactory f;
    function setUp() {
    }
    function testCreateCostMain() logs_gas() {
        f = (new DSFactoryTestFactory()).buildFactory();
    }
}
