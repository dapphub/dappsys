contract DSBaseProxy {
    function exec( address target, uint value, bytes calldata )
             returns (bool call_ret, bool ok);
    function _exec( address target, uint value, bytes calldata )
             internal
             returns (bool call_ret, bool ok)
    {
        call_ret = target.call.value(value)(calldata);
        ok = true;
    }

}

// Simple example and passthrough for testing
contract DSSimpleProxy is DSBaseProxy {
    function exec( address target, uint value, bytes calldata )
             returns (bool call_ret, bool ok)
    {
        return _exec( target, value, calldata );
    }
}


