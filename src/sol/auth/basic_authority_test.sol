import 'dapple/test.sol';
import 'auth/authority.sol';
import 'auth/auth_test.sol';  // Vault


contract BasicAuthorityTest is Test {
    DSBasicAuthority a;
    DSBasicAuthority a2;
    Vault v;
    function setUp() {
        a = new DSBasicAuthority();
        v = new Vault();
        v.updateAuthority(a, true);
    }
    function testExportAuthorized() {
        v.breach();
        this.assertFalse( v.breached() );
        var ok = a.exportAuthorized( DSAuth(v), address(this), false );
        assertTrue( ok, "failed to export" );
        v.breach();
        assertTrue( v.breached(), "couldn't breach w/ permission" );
    }
    function testNormalWhitelistAdd() {
        v.breach();
        this.assertFalse( v.breached() );
        a.setCanCall( me, address(v), 0x0b6142fc, true );
        v.breach();
        assertTrue( v.breached() );
        v.reset();
        a.setCanCall( me, address(v), 0x0b6142fc, false );
        v.breach();
        this.assertFalse( v.breached() );
    }
}
