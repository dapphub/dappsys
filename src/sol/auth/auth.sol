// `DSAuth` is a mixin contract which enables standard authorization patterns.
// Its full name could be `DSAuthorized` (TODO add alias?), indicated it is the
// contract that is controlled, and to make clear it is not the `DSAuthority`.
contract DSAuth {
    // Currently, two authority modes are defined:
    // * "simple auth", where `auth()` simply checks if the sender is `_ds_authority`
    // * "remote auth", where `auth()` first makes a call to
    // `DSAuthority(_ds_authority).canCall(sender, this, sig)`
    uint8 _ds_mode;
    address _ds_authority;
    function DSAuth() {
        _ds_authority = msg.sender;
        _ds_mode = 0; //DSAuthModes.Owned;
    }
    // Attach the `auth()` modifier this to functions to protect them.
    modifier auth() {
        if( _ds_authenticated() ) {
            _
        }
    }
    // An internal helper function for if you want to use the `auth()` logic
    // someplace other than the modifier
    function _ds_authenticated() internal returns (bool is_authenticated) {
        if( _ds_mode == 0 && msg.sender == _ds_authority ) {
            return true;
        } else if ( _ds_mode == 1 ) {
            if( msg.sender == _ds_authority ) {
                return true;
            }
            var A = DSAuthority(_ds_authority);
            return A.canCall( msg.sender, address(this), msg.sig );
        } else {
            return false;
        }
    }
    function _ds_get_authority() constant returns (address authority, bool ok) {
        return (_ds_authority, true);
    }
    // This function is used to both transfer the authority and update the mode.
    // Be extra careful about setting *both* correctly every time.
    function _ds_update_authority( address new_authority, uint8 mode )
             auth()
             returns (bool success)
    {
        _ds_authority = DSAuthority(new_authority);
        _ds_mode = mode;
        return true;
    }
}

// Use the auth() pattern, but compile the address into code instead
// of into storage. This is useful if you need to use the entire address
// space, for example.
contract DSStaticAuth {
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
