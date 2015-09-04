contract DSSync {
    DSMigratable[1024] _m;
    uint _num_migratable;
    // Call this in subclass's constructor
    function sync_with(DSMigratable m) internal returns (uint which) {
        _m[_num_migratable] = m;
        var ret = _num_migratable;
        _num_migratable++;
        return ret;
    }
    function _ds_sync() {
        for( var i = 0; i < _num_migratable; i++ ) {
            while( true ) {
                var current = _m[i];
                var update = DSMigratable(current._ds_get_update());
                if( update == current || update == DSMigratable(0x0) ) { 
                    break;
                }
                _m[i] = update;
            }
        }
    }
    // make modifiers like this to copy updates to local variables
    // TODO we could eliminate a copy and a lookup if we had direct
    // access to storage in solidity
    modifier syncs() {
        _ds_sync();
        _
    }
}
