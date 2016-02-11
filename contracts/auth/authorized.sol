import 'auth/authority.sol';

contract DSAuthorizedEvents {
    event DSAuthUpdate( address auth, bool mode );
}

// `DSAuthorized` is a mixin contract which enables standard authorization patterns.
// It has a shorter alias `auth/auth.sol: DSAuth` because it is so common.
contract DSAuthorized is DSAuthorizedEvents {
    // There are two "modes":
    // * "owner mode", where `auth()` simply checks if the sender is `_authority`.
    //   This is the default mode, when `_auth_mode` is false.
    // * "authority mode", where `auth()` makes a call to
    // `DSAuthority(_authority).canCall(sender, this, sig)` to ask if the
    // call should be allowed. (It also first does the "owner" mode check,
    // which massively writing and using `DSAuthority` implementations without
    // changing the security properties very much.)
    bool    public _auth_mode;
    address public _authority;

    function DSAuthorized() {
        _authority = msg.sender;
        _auth_mode = false;
        DSAuthUpdate( msg.sender, false );
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
        // If we are in "authority" mode, use `canCall`
        if( _auth_mode == true ) {
            var A = DSAuthority(_authority);
            return A.canCall( msg.sender, address(this), msg.sig );
        } else { // else we are in "owner" mode, see if the owner is the sender
            return (msg.sender == _authority);
        }
    }

    // This function is used to both transfer the authority and update the mode.
    // Be extra careful about setting *both* correctly every time.
    // sig:6cd22eaf
    function updateAuthority( address new_authority, bool mode )
             auth()
    {
        _authority = new_authority;
        _auth_mode = mode;
        DSAuthUpdate( new_authority, mode );
    }
}
