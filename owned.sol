// DSProtected in the more familiar "owned" pattern.
// This overrides auth() to simply check the sender
// is the authority rather than call it for permission.
import 'dappsys/test/debug.sol';

contract DSOwned is DSProtected {
    bool _ds_owned;
    function DSOwned() {
        _ds_init_authority( DSAuthorityInterface(msg.sender) );
        _ds_owned = true;
    }
    function _ds_set_owned_status( bool what )
             auth()
    {
        _ds_owned = what;
    }
    modifier auth() {
        if( _ds_owned ) {
            if( msg.sender == address(_ds_protector) ) {
                _
            }
        } else {
            var can_call = _ds_protector.can_call( msg.sender, address(this), msg.sig );
            if( can_call ) {
                //logs("authorized.");
                _
            }
        }
    }
}
