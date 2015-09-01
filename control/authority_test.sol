import 'dapple/test/test.sol';
import 'dappsys/control/authority.sol';
import 'dappsys/control/auth_test.sol';  // Vault


contract AuthorityTest is Test {
    DSAuthority a;
    Vault v;
    function setUp() {
        a = new DSAuthority();
        v = new Vault();
    }
}
