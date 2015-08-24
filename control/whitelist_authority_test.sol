import 'dappsys/test/test.sol';

contract whitelist_authority_tester {
    DSWhitelistAuthority _a;
    function AuthRoot(DSWhitelistAuthority a) {
        _a = a;
    }
    function SetRoot( address who ) {
        //TODO
    }
}
contract WhitelistAuthorityTest is Test {
    DSWhitelistAuthority a;
    function setUp() {
        a = new DSWhitelistAuthority();
    }
    function testCreatorIsRoot() {
        assertTrue(a._is_root(address(this)));
    }
    function testRootCanSetRule() {
        //TODO incomplete
    }
}
