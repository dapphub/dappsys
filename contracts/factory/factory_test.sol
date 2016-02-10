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
    function testBuildTokenSystemCostWithAuth() logs_gas() {
        tmp_auth.updateAuthority(address(f), false);
        f.buildDSTokenBasicSystem(tmp_auth);
    }
    function testBuildTokenSystemCostNewAuth() logs_gas() {
        f.buildDSTokenBasicSystem(DSBasicAuthority(0x0));
    }
}

