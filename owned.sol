// DSProtected in the more familiar "owned" pattern.
import 'dappsys/test/debug.sol';

contract DSOwned is DSProtected {
    function DSOwned() {
        _ds_init_protector( DSProtectorInterface(msg.sender) );
    }
}
