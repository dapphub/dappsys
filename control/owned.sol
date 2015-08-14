// DSProtected in the more familiar "owned" pattern.
// This overrides auth() to simply check the sender
// is the authority rather than call it for permission.
// Authority can toggle between "owned" and "protected" modes.
import 'dappsys/test/debug.sol';
import 'dappsys/control/protected.sol';

contract DSOwned is DSProtected {
    bool _ds_owned;
    function DSOwned() {
        _ds_set_authority( DSAuthorityInterface(msg.sender) );
        _ds_owned = true;
    }
    function _ds_set_owned_status( bool what )
             auth()
    {
        _ds_owned = what;
    }
    function authed() internal returns (bool) {
        if( _ds_owned ) {
            if( msg.sender == address(_ds_authority) ) {
                return true;
            }
        } else {
            var can_call = _ds_authority.can_call(msg.sender, address(this), msg.sig);
            if( can_call ) {
                return true;
            }
        }
        return false;
    }
}
