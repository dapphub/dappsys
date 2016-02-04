import 'dapple/test.sol';
import 'token/deployer.sol';
import 'token/token_test.sol';
import 'factory/factory.sol';

contract TokenSetupTest is Test {
    TokenTester tester;
    DSFactory f;
    DSTokenDeployer deployer;
    DSToken t;
    DSBasicAuthority auth;
    function setUp() {
        f = (new DSFactoryTestFactory()).buildFactory();
        deployer = new DSTokenDeployer(f);
        tester = new TokenTester();
        (t, auth) = deployer.deploy(DSBasicAuthority(0x0), address(tester), 100);
    }
    function testSystem() {
        assertTrue( tester.runTest( t ) );
    }
    function testOwnAuth() {
        assertTrue( auth._authority() == address(this) );
        assertTrue( auth._auth_mode() == false );
    }
}

