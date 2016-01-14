import 'dapple/test.sol';
import 'token/deployer.sol';
import 'token/token_test.sol';

contract TokenSetupTest is Test {
    TokenTester tester;
    DSTokenDeployerFactory factory;
    DSTokenDeployer deployer;
    DSToken t;
    function setUp() {
        factory = new DSTokenDeployerFactory(new DSBalanceDBFactory(), new DSApprovalDBFactory());
        deployer = factory.build();
        tester = new TokenTester();
        deployer.deploy(address(tester), 100);
        t = DSTokenFrontend( deployer.contracts("frontend") );
    }
    function testSystem() {
        assertTrue( tester.runTest( t ) );
    }
}

