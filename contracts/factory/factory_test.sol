import 'factory/factory.sol';
import 'auth/authority.sol';
import 'dapple/test.sol';

contract TestFactoryUser {
    DSAuthFactory auth;
    DSDataFactory data;
    DSTokenFactory token;
    DSMultisigFactory ms;
    DSFactory f;

    function TestFactoryUser() {
        auth = new DSAuthFactory();
        data = new DSDataFactory();
        token = new DSTokenFactory(auth, data);
        ms = new DSMultisigFactory();
        f = new DSFactory1(data, token, ms, auth);
    }
}

contract FactoryTest is Test, TestFactoryUser {
    DSBasicAuthority tmp_auth;
    function setUp() {
        tmp_auth = f.buildDSBasicAuthority();
        tmp_auth.updateAuthority(address(f), false);
    }
    function testCreateCostData() logs_gas() {
        data = new DSDataFactory();
    }
    function testCreateCostToken() logs_gas() {
        token = new DSTokenFactory(auth, data);
    }
    function testCreateCostMultisig() logs_gas() {
        ms = new DSMultisigFactory();
    }
    function testCreateCostAuth() logs_gas() {
        auth = new DSAuthFactory();
    }
    function testCreateCostMain() logs_gas() {
        f = new DSFactory1(data, token, ms, auth);
    }
    function testBuildTokenSystemCost() logs_gas() {
        f.buildDSTokenBasicSystem(tmp_auth);
    }
}

