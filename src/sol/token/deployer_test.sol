import 'dapple/test.sol';
import 'token/deployer.sol';
import 'token/token_test.sol';
import 'factory/factory.sol';

contract TokenSetupTest is Test {
    TokenTester tester;
    DSFactory f;
    DSTokenDeployer deployer;
    DSToken t;
    function setUp() {
        f = new DSFactory1();
        deployer = new DSTokenDeployer(f);
        tester = new TokenTester();
        deployer.deploy(address(tester), 100);
        t = DSTokenFrontend( deployer.contracts("frontend") );
    }
    function testSystem() {
        assertTrue( tester.runTest( t ) );
    }
}

