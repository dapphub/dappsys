contract DSTransient {
    function _ds_get_update() returns (address);
}

contract DSTransientContractConsumer {
    DSTransient t;
    function DSTransientContractConsumer( DSTransient _t ) {
        t = _t;
    }
    function _ds_sync() {
        while( true ) {
            var update = DSTransient(t._ds_get_update());
            if( update == t ) { 
                break;
            }
            t = update;
        }
    }
    modifier syncs() {
        _ds_sync();
        _
    }
}
