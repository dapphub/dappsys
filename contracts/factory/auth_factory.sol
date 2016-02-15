import 'auth.sol';
import 'auth/basic_authority.sol';

contract DSAuthFactory is DSAuthUser {
    function buildDSBasicAuthority() returns (DSBasicAuthority ret) {
        ret = new DSBasicAuthority();
        setOwner( ret, msg.sender );
    }
}
