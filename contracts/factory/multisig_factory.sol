import 'auth.sol';
import 'gov/easy_multisig.sol';

contract DSMultisigFactory is DSAuthUser {
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig ret)
    {
        ret = new DSEasyMultisig( n, m, expiration );
        setOwner( ret, msg.sender );
    }
}
