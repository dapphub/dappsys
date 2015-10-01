import 'dapple/core/debug.sol';

contract DSUpdateChain is Debug {
    address _ds_latest_version;
    function DSUpdateChain() {
        _ds_latest_version = address(this);
    }
    function is_latest() internal returns (bool) {
        return _ds_get_latest_version() == address(this);
    }
    modifier disabled_on_update() {
        if( is_latest() ) {
            _
        }
    }
    function _ds_get_latest_version() returns (address) {
        if( _ds_latest_version == address(this) ) {
            return address(this);
        }
        var last = _ds_latest_version;
        var next = DSUpdateChain(_ds_latest_version)._ds_get_latest_version();
        while( last != next ) {
            last = next;
            next = DSUpdateChain(_ds_latest_version)._ds_get_latest_version();
        }
        _ds_latest_version = next;
        return _ds_latest_version;
    }
    function _ds_set_latest_version( address version )
             // auth()
             internal // to avoid auth dependency, let dev choose how to use it
    {
        _ds_latest_version = version;
    }

    /*
    function latest_version() returns (YOUR_TYPE) {
        return YOUR_TYPE(_ds_latest_version);
    }

    */
}

/*
contract UINTgetter {
    function get() returns (uint);
}

contract DSForwardingUpdateChain is DSUpdateChain {
    modifier forwards_uint() {
        if( is_latest() ) {
            _
        } else {
            return UINTgetter(_ds_latest_version).get();
        }
    }
}
*/
