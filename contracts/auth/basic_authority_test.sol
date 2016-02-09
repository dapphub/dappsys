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
        a.setCanCall( address(this), address(v), bytes4(sha3("updateAuthority(address,bool)")), true );
        v.updateAuthority( address(this), false );
        v.breach();
        assertTrue( v.breached(), "couldn't after export attempt" );
    }
    function testFailBreach() {
        v.breach(); // throws
    }
    function testNormalWhitelistAdd() {
        a.setCanCall( me, address(v), bytes4(sha3("breach()")), true );
        v.breach();
        assertTrue( v.breached() );
        v.reset();
    }
    function testFailNormalWhitelistReset() {
        a.setCanCall( me, address(v), bytes4(sha3("breach()")), true );
        v.breach();
        assertTrue( v.breached() );
        a.setCanCall( me, address(v), bytes4(sha3("breach()")), false );
        v.breach();
    }
}
