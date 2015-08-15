import 'dappsys/control/authority.sol';

contract DSProtectedInterface {
    function _ds_set_authority( DSAuthorityInterface authority ) returns (bool);
    modifier auth() {}
}

contract DSProtected is DSAuth {
    function DSProtected() {
        _ds_auth_mode = 0x1;
    }
}
/*
contract DSProtected is DSProtectedInterface {
    DSAuthorityInterface public _ds_authority;
    modifier auth() {
        if( authed() ) {
            _
        }
    }
    function authed() internal returns (bool) {
        if( address(_ds_authority) != address(0x0) ) {
            return _ds_authority.can_call( msg.sender, address(this), msg.sig );
        }
        return false;
    }

    function _ds_set_authority (DSAuthorityInterface authority )
             returns (bool success)
    {
        if( address(_ds_authority) == address(0x0) ) {
            _ds_authority = authority;
            return true;
        } else {
            if( authed() ) {
                _ds_authority = authority;
                return true;
            }
            return false;
        }
    }
}
*/
