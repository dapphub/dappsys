import 'factory/factory.sol';
import 'auth/authority.sol';
import 'dapple/test.sol';

contract TestFactoryUser {
    DSAuthFactory authFactory;
    DSDataFactory dataFactory;
    DSTokenFactory tokenFactory;
    DSMultisigFactory msFactory;
    DSFactory factory;

    function TestFactoryUser() {
        authFactory = new DSAuthFactory();
        dataFactory = new DSDataFactory();
        tokenFactory = new DSTokenFactory(authFactory, dataFactory);
        msFactory = new DSMultisigFactory();
        factory = new DSFactory1(dataFactory, tokenFactory,
                                 msFactory, authFactory);
    }
}

contract FactoryTest is Test, TestFactoryUser {
    DSBasicAuthority tmp_auth;
    function setUp() {
        tmp_auth = factory.buildDSBasicAuthority();
    }
    function testCreateCostData() logs_gas() {
        dataFactory = new DSDataFactory();
    }
    function testCreateCostToken() logs_gas() {
        tokenFactory = new DSTokenFactory(authFactory, dataFactory);
    }
    function testCreateCostMultisig() logs_gas() {
        msFactory = new DSMultisigFactory();
    }
    function testCreateCostAuth() logs_gas() {
        authFactory = new DSAuthFactory();
    }
    function testCreateCostMain() logs_gas() {
        factory = new DSFactory1(dataFactory, tokenFactory,
                                 msFactory, authFactory);
    }
    function testBuildTokenSystemCostWithAuth() logs_gas() {
        tmp_auth.updateAuthority(address(factory), false);
        factory.buildDSTokenBasicSystem(tmp_auth);
    }
    function testBuildTokenSystemCostNewAuth() logs_gas() {
        factory.buildDSTokenBasicSystem(DSBasicAuthority(0x0));
    }
}

