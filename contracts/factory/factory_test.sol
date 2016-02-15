import 'auth.sol';
import 'factory/factory.sol';
import 'dapple/test.sol';

contract TestFactoryUser is DSAuthUser {
    DSAuthFactory authFactory;
    DSDataFactory dataFactory;
    DSTokenFactory tokenFactory;
    DSTokenInstaller tokenInstaller;
    DSMultisigFactory msFactory;
    DSFactory factory;

    function TestFactoryUser() {
        authFactory = new DSAuthFactory();
        dataFactory = new DSDataFactory();
        tokenFactory = new DSTokenFactory();
        tokenInstaller = new DSTokenInstaller(authFactory, dataFactory, tokenFactory);
        msFactory = new DSMultisigFactory();
        
        factory = new DSFactory1(authFactory, dataFactory,
                                 msFactory, tokenFactory, tokenInstaller);
    }
}

contract FactoryTest is Test, TestFactoryUser {
    DSBasicAuthority tmp_auth;
    function setUp() {
        tmp_auth = factory.buildDSBasicAuthority();
        tmp_auth.updateAuthority(address(factory), DSAuthModes.Owner );
    }
    function testCreateCostData() logs_gas() {
        dataFactory = new DSDataFactory();
    }
    function testCreateCostToken() logs_gas() {
        tokenFactory = new DSTokenFactory();
    }
    function testCreateCostMultisig() logs_gas() {
        msFactory = new DSMultisigFactory();
    }
    function testCreateCostAuth() logs_gas() {
        authFactory = new DSAuthFactory();
    }
    function testCreateCostMain() logs_gas() {
        factory = new DSFactory1(authFactory, dataFactory,
                                 msFactory, tokenFactory, tokenInstaller);
    }
    function testBuildTokenSystemCost() logs_gas() {
        factory.installDSTokenBasicSystem(tmp_auth);
    }
}

