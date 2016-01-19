import 'factory/factory.sol';
import 'dapple/test.sol';

contract FactoryTest is Test {
    DSDataFactory data;
    DSTokenFactory token;
    DSMultisigFactory ms;
    DSAuthFactory auth;
    DSFactory f;
    function setUp() {
        data = new DSDataFactory();
        token = new DSTokenFactory();
        ms = new DSMultisigFactory();
        auth = new DSAuthFactory();
        var f = new DSFactory1(data, token, ms, auth);
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
    function testCreateCostAuth() logs_gas() {
        var ms = new DSAuthFactory();
    }
    function testCreateCostMain() logs_gas() {
        var f = new DSFactory1(data, token, ms, auth);
    }
}
