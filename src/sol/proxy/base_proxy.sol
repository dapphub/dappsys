contract DSBaseProxy {
    function execute( address target, uint value, bytes calldata )
             returns (bytes32 call_id, bool ok);
    function result( bytes32 call_id ) returns (bool executed, bool call_ret, bool ok);

    function _call( address target, uint value, bytes calldata )
             internal
             returns (bool call_ret, bytes32 call_id, bool ok)
    {
        call_ret = target.call.value(value)(calldata);
        ok = true;
    }
}

// Simple example and passthrough for testing
contract DSSimpleProxy is DSBaseProxy {
    function execute( address target, uint value, bytes calldata )
             returns (bytes32 call_id, bool ok)
    {
        var (ok1, id, ok2) = _call( target, value, calldata );
        return (id, ok1 && ok2);
    }
    function result( bytes32 call_id ) returns (bool executed, bytes call_ret, bool ok) {
        return (false, bytes(0x0), false);
    }
}


