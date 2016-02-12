import 'auth.sol';
import 'auth/basic_authority.sol';

contract DSAuthFactory is DSAuthUser {
    function buildDSBasicAuthority() returns (DSBasicAuthority) {
        var c = new DSBasicAuthority();
        c.updateAuthority(msg.sender, DSAuthModes.Owner );
        return c;
    }
}
