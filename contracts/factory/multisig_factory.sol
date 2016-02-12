import 'auth.sol';
import 'gov/easy_multisig.sol';

contract DSMultisigFactory {
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig)
    {
        var c = new DSEasyMultisig( n, m, expiration );
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
        return c;
    }
}
