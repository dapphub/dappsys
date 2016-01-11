import 'dapple/test.sol';
import 'token/deployer.sol';
import 'token/token_test.sol';

contract TokenSetupTest is Test {
    TokenTester tester;
    DSTokenDeployer deployer;
    DSToken t;
    function setUp() {
        deployer = new DSTokenDeployer();
        tester = new TokenTester();
        deployer.deploy(address(tester), 100);
        t = DSTokenFrontend( deployer.contracts("frontend") );
    }
    function testSystem() {
        assertTrue( tester.runTest( t ) );
    }
}

