import 'factory/factory.sol';
import 'dapple/test.sol';

contract FactoryTest is Test {
    DSDataFactory data;
    DSTokenFactory token;
    DSMultisigFactory ms;
    DSFactory f;
    function setUp() {
        var data = new DSDataFactory();
        var token = new DSTokenFactory();
        var ms = new DSMultisigFactory();
        var f = new DSFactory1(data, token, ms);
    }
    function testCreateCostData() logs_gas() {
        var data = new DSDataFactory();
    }
    function testCreateCostToken() logs_gas() {
        var token = new DSTokenFactory();
    }
    function testCreateCostMultisig() logs_gas() {
        var ms = new DSMultisigFactory();
    }
    function testCreateCostMain() logs_gas() {
        var f = new DSFactory1(data, token, ms);
    }
}
