import 'dappsys/test/debug.sol';

contract DSAuthorityInterface is Debug {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return false;
    }
    function() returns (bool) {
        return false;
    }
}

contract DSProtectedInterface {
    DSAuthorityInterface _ds_protector;
    function _ds_change_authority( DSAuthorityInterface protector ) returns (bool);
    function _ds_init_authority( DSAuthorityInterface protector );
    modifier auth() {}
}
contract DSProtected is DSProtectedInterface, Debug {
    DSAuthorityInterface public _ds_protector;
    modifier auth() {
        //log_named_address("protector is:", _ds_protector);
        var can_call = _ds_protector.can_call( msg.sender, address(this), msg.sig );
        //log_named_bool("can_call", can_call);
        if( can_call ) {
            //logs("authorized.");
            _
        }
    }
    function _ds_init_authority( DSAuthorityInterface protector ) {
        if( address(_ds_protector) == address(0x0) ) {
            _ds_protector = protector;
        }
    }
    function _ds_change_authority( DSAuthorityInterface protector )
             auth()
             returns (bool ok)
    {
        _ds_protector = protector;
    }
}
