import 'dappsys/test/debug.sol';

contract DSProtectorInterface is Debug {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool) {
        return false;
    }
    function() returns (bool) {
        return false;
    }
}

contract DSProtectedInterface {
    DSProtectorInterface _ds_protector;
    function _ds_change_protector( DSProtectorInterface protector ) returns (bool);
    function _ds_init_protector( DSProtectorInterface protector );
    modifier auth() {}
}
contract DSProtected is DSProtectedInterface, Debug {
    DSProtectorInterface public _ds_protector;
    modifier auth() {
        //log_named_address("protector is:", _ds_protector);
        var can_call = _ds_protector.can_call( msg.sender, address(this), msg.sig );
        //log_named_bool("can_call", can_call);
        if( can_call ) {
            //logs("authorized.");
            _
        }
    }
    function _ds_init_protector( DSProtectorInterface protector ) {
        if( address(_ds_protector) == address(0x0) ) {
            _ds_protector = protector;
        }
    }
    function _ds_change_protector( DSProtectorInterface protector )
             auth()
             returns (bool ok)
    {
        _ds_protector = protector;
    }
}
