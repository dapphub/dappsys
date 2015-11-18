// @brief Mixin contract to enable standard authorization pattern.
contract DSAuth {
    uint _ds_mode;
    address _ds_authority;
    function DSAuth() {
        _ds_authority = msg.sender;
        _ds_mode = 0; //DSAuthModes.Owned;
    }
    modifier auth() {
        if( _ds_authenticated() ) {
            _
        }
    }
    function _ds_authenticated() internal returns (bool is_authenticated) {
        if( _ds_mode == 0 && msg.sender == _ds_authority ) {
            return true;
        } else if ( _ds_mode == 1 ) {
            if( msg.sender == _ds_authority ) {
                return true;
            }
            var A = DSAuthority(_ds_authority);
            return A.can_call( msg.sender, address(this), msg.sig );
        } else {
            return false;
        }
    }
    function _ds_get_authority() constant returns (address authority, bool ok) {
        return (_ds_authority, true);
    }
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
// @brief DSAuth-like mixin contract which puts the authority address
//        into code instead of storage. 
// @dev Optionally implement missing DSAuth functions with your constant address
contract DSStaticAuth {
    function _ds_authenticated( address _ds_authority ) internal returns (bool is_authenticated) {
        if( msg.sender == _ds_authority ) {
            return true;
        }
        var A = DSAuthority(_ds_authority);
        return A.can_call( msg.sender, address(this), msg.sig );
    }
    modifier static_auth( address _ds_authority ) {
        if( _ds_authenticated( _ds_authority ) ) {
            _
        }
    }
    // Implement these with your constant address to make this into a proper DSAuth
    // function _ds_get_authority() constant returns (address authority);
    // function _ds_update_authority( address new_authority ) returns (bool success);
}
