import 'auth.sol';
import 'auth/basic_authority.sol';

contract DSAuthFactory {
    function buildDSBasicAuthority() returns (DSBasicAuthority) {
        var c = new DSBasicAuthority();
        c.updateAuthority(msg.sender, DSAuthModes.Owned );
        return c;
    }
}
