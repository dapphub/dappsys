import 'dappsys/control/authority.sol';
import 'dappsys/test/debug.sol';

contract DSAuth is Debug {
    // TODO use enums
    // these are only here because consts and enums don't work 
    // 0x0:   authority == sender
    // 0x1:   authority._ds_is_authorized( sender, this, sig )
    byte                    public   _ds_auth_mode;
    address                 public   _ds_authority;

    function DSAuth() {
        _ds_authority = msg.sender;
    }

    modifier auth() {
        if( authed() ) {
            _
        }
    }
    function authed() internal returns (bool) {
        if ( _ds_auth_mode == 0x0 ) {
            return msg.sender == _ds_authority;
        }
        if (_ds_auth_mode == 0x1) {
            var A = DSAuthorityInterface(_ds_authority);
            return A.can_call( msg.sender, address(this), msg.sig );
        }
        return false;
    }
    function _ds_set_auth_mode(byte mode) auth() returns (bool) {
        _ds_auth_mode = mode;
    }
    function _ds_set_authority(address authority) auth() returns (bool) {
        _ds_authority = authority;
    }

    // TODO use enums
    // these are only here because consts and enums don't work 
    function _ds_set_auth_mode_owned() auth() returns (bool) {
        _ds_auth_mode = 0x0;
    }
    function _ds_set_auth_mode_authority() auth() returns (bool) {
        _ds_auth_mode = 0x1;
    }
}
