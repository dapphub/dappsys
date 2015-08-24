import 'dappsys/control/authority.sol';
import 'dappsys/test/debug.sol';

contract DSAuth {
    // TODO use enums
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
    function authed() internal returns (bool authorized)
    {
        if ( _ds_auth_mode == 0x0 ) {
            return msg.sender == _ds_authority;
        }
        if (_ds_auth_mode == 0x1) {
            var A = DSAuthorityInterface(_ds_authority);
            return A.can_call( msg.sender, address(this), msg.sig );
        }
        return false;
    }
    function _ds_set_authority( address authority
                              , byte mode )
             auth()
             returns (bool)
    {
        _ds_authority = authority;
        _ds_auth_mode = mode;
        return true;
    }
}
