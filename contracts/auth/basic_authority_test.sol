import 'dapple/test.sol';
import 'auth/authority.sol';
import 'auth/auth_test.sol';  // Vault
import 'auth/basic_authority.sol';


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
        a.setCanCall( address(this), address(v), 0x0, true );
        a.updateAuthority( address(this), false );
        v.breach();
        assertTrue( v.breached(), "couldn't after export attempt" );
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
