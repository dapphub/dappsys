contract DSUpdateChain {
    function DSUpdateChain() {
        _ds_latest_version = address(this);
    }
    address _ds_latest_version;
    function _ds_get_latest_version() returns (address) {
        if( _ds_latest_version != address(this) ) {
            _ds_latest_version = DSUpdateChain(_ds_latest_version)._ds_get_latest_version();
        }
        return _ds_latest_version;
    }
    function _ds_set_latest_version( address version )
             internal // to avoid auth dependency, let dev choose how to use it
    {
        _ds_latest_version = version;
    }
}
