import 'auth/authority.sol';

// `DSAuthorized` is a mixin contract which enables standard authorization patterns.
// It has a shorter alias `auth/auth.sol: DSAuth` because it is so common.
contract DSAuthorized {
    // There are two "modes":
    // * "owner mode", where `auth()` simply checks if the sender is `_authority`.
    //   This is the default mode, when `_auth_mode` is false.
    // * "authority mode", where `auth()` makes a call to
    // `DSAuthority(_authority).canCall(sender, this, sig)` to ask if the
    // call should be allowed. (It also first does the "owner" mode check,
    // which massively writing and using `DSAuthority` implementations without
    // changing the security properties very much.)
    bool    _auth_mode;
    address _authority;

    event DSAuthUpdate( address auth, bool mode );

    function DSAuthorized() {
        _authority = msg.sender;
        _auth_mode = false;
        DSAuthUpdate( msg.sender, false );
    }

    // Attach the `auth()` modifier this to functions to protect them.
    modifier auth() {
        if( isAuthorized() ) {
            _
        }
    }
    // An internal helper function for if you want to use the `auth()` logic
    // someplace other than the modifier (like in a fallback function).
    function isAuthorized() internal returns (bool is_authorized) {
        if( msg.sender == _authority ) {
            return true;
        }
        if( _auth_mode == true ) {
            var A = DSAuthority(_authority);
            return A.canCall( msg.sender, address(this), msg.sig );
        }
        return false;
    }

    function getAuthority() constant returns (address authority, bool mode ) {
        return (_authority, _auth_mode);
    }
    // This function is used to both transfer the authority and update the mode.
    // Be extra careful about setting *both* correctly every time.
    function updateAuthority( address new_authority, bool mode )
             auth()
             returns (bool success)
    {
        _authority = DSAuthority(new_authority);
        _auth_mode = mode;
        DSAuthUpdate( new_authority, mode );
        return true;
    }
}
