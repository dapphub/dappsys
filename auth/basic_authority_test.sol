import 'core/test.sol';
import 'auth/authority.sol';
import 'auth/auth_test.sol';  // Vault


contract BasicAuthorityTest is Test {
    DSBasicAuthority a;
    DSBasicAuthority a2;
    Vault v;
    function setUp() {
        a = new DSBasicAuthority();
        v = new Vault();
        v._ds_set_authority(a, 0x1);
    }
    function testExportAuthorized() {
        v.breach();
        assertFalse( v.breached() );
        a.export_authorized( DSAuth(v), DSAuthority(this), 0x0 );
        v.breach();
        assertTrue( v.breached(), "couldn't breach w/ permission" );
    }
    function testNormalWhitelistAdd() {
        v.breach();
        assertFalse( v.breached() );
        a.set_can_call( me, address(v), 0x0b6142fc, true );
        v.breach();
        assertTrue( v.breached() );
        v.reset();
        a.set_can_call( me, address(v), 0x0b6142fc, false );
        v.breach();
        assertFalse( v.breached() );
    }
}
