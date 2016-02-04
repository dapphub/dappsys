import 'dapple/test.sol';
import 'token/deployer.sol';
import 'token/token_test.sol';
import 'factory/factory.sol';

contract TokenSystemTest is TokenTest {
    DSFactory f;
    DSTokenDeployer deployer;
    DSBasicAuthority auth;
    function setUp() {
        f = (new DSFactoryTestFactory()).buildFactory();
        deployer = new DSTokenDeployer(f);
        (t, auth) = deployer.deploy(DSBasicAuthority(0x0), address(this), 100);
    }
    function testOwnAuth() {
        assertTrue( auth._authority() == address(this) );
        assertTrue( auth._auth_mode() == false );
    }
}

