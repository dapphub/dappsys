// `DSAuthorized` is a mixin contract which enables standard authorization patterns. It has a shorter alias `auth/auth.sol: DSAuth` because it is so common.
contract DSAuthorized {
    // There are two "modes":
    // * "owner mode", where `auth()` simply checks if the sender is `_ds_authority`.
    //   This is the default mode, when `_ds_auth_mode` is false.
    // * "authority mode", where `auth()` first makes a call to
    // `DSAuthority(_ds_authority).canCall(sender, this, sig)`
    bool    _ds_auth_mode;
    address _ds_authority;

    event DSAuthUpdate( address auth, bool mode );

    function DSAuthorized() {
        _ds_authority = msg.sender;
        _ds_auth_mode = false;
        DSAuthUpdate( msg.sender, false );
    }

    function _ds_auth_info() constant returns (address authority, bool mode, bool ok) {
        return (_ds_authority, _ds_auth_mode, true);
    }

    // Attach the `auth()` modifier this to functions to protect them.
    modifier auth() {
        if( _ds_authenticated() ) {
            _
        }
    }
    // An internal helper function for if you want to use the `auth()` logic
    // someplace other than the modifier (like in a fallback function).
    function _ds_authenticated() internal returns (bool is_authenticated) {
        if( _ds_auth_mode == false && msg.sender == _ds_authority ) {
            return true;
        } else if ( _ds_auth_mode == true ) {
            if( msg.sender == _ds_authority ) {
                return true;
            }
            var A = DSAuthority(_ds_authority);
            return A.canCall( msg.sender, address(this), msg.sig );
        } else {
            return false;
        }
    }
    // This function is used to both transfer the authority and update the mode.
    // Be extra careful about setting *both* correctly every time.
    function _ds_update_authority( address new_authority, bool mode )
             auth()
             returns (bool success)
    {
        _ds_authority = DSAuthority(new_authority);
        _ds_auth_mode = mode;
        DSAuthUpdate( new_authority, mode );
        return true;
    }
}

// Use the auth() pattern, but compile the address into code instead
// of into storage. This is useful if you need to use the entire address
// space, for example. The tradeoff is that you cannot update the authority.
contract DSStaticAuthorized {
    function _ds_authenticated( address _ds_authority ) internal returns (bool is_authenticated) {
        if( msg.sender == _ds_authority ) {
            return true;
        }
        var A = DSAuthority(_ds_authority);
        return A.canCall( msg.sender, address(this), msg.sig );
    }
    modifier static_auth( address _ds_authority ) {
        if( _ds_authenticated( _ds_authority ) ) {
            _
        }
    }
    // Optionally implement missing DSAuth functions with your constant address
    // to be fully compatible - no way to do this in general
    // `function _ds_get_authority() constant returns (address authority);`
    // `function _ds_update_authority( address new_authority ) returns (bool success);`
}
