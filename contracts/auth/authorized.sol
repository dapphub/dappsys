// import this as "auth.sol" and use "DSAuth"
import 'auth/enum.sol';
import 'auth/events.sol';
import 'auth/authority.sol';

// `DSAuthorized` is a mixin contract which enables standard authorization patterns.
// It has a shorter alias `auth/auth.sol: DSAuth` because it is so common.
contract DSAuthorized is DSAuthModesEnum, DSAuthorizedEvents
{
    // There are two "modes":
    // * "owner mode", where `auth()` simply checks if the sender is `_authority`.
    //   This is the default mode, when `_auth_mode` is false.
    // * "authority mode", where `auth()` makes a call to
    // `DSAuthority(_authority).canCall(sender, this, sig)` to ask if the
    // call should be allowed.
    DSAuthModes  public _auth_mode;
    DSAuthority  public _authority;

    function DSAuthorized() {
        _authority = DSAuthority(msg.sender);
        _auth_mode = DSAuthModes.Owner;
        DSAuthUpdate( msg.sender, DSAuthModes.Owner );
    }

    // Attach the `auth()` modifier to functions to protect them.
    modifier auth() {
        if( isAuthorized() ) {
            _
        } else {
            throw;
        }
    }
    // A version of `auth()` which implicitly returns 0 instead of throwing.
    modifier try_auth() {
        if( isAuthorized() ) {
            _
        }
    }

    // An internal helper function for if you want to use the `auth()` logic
    // someplace other than the modifier (like in a fallback function).
    function isAuthorized() internal returns (bool is_authorized) {
        if( _auth_mode == DSAuthModes.Owner ) {
            return msg.sender == address(_authority);
        }
        if( _auth_mode == DSAuthModes.Authority ) { // use `canCall` in "authority" mode
            return _authority.canCall( msg.sender, address(this), msg.sig );
        }
        throw;
    }

    // This function is used to both transfer the authority and update the mode.
    // Be extra careful about setting *both* correctly every time.
    function updateAuthority( address new_authority, DSAuthModes mode )
             auth()
    {
        _authority = DSAuthority(new_authority);
        _auth_mode = mode;
        DSAuthUpdate( new_authority, mode );
    }
}
