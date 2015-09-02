contract Logger {
    // ** Centralized Logging
    function log( bytes32 key, bytes value) external {
        kernel_event(key, value);
    }
    event kernel_event( bytes32 indexed key, bytes value );
    event kernel_event2( bytes32 indexed key
                       , bytes32 indexed key2
                       , bytes value );
    event kernel_event3( bytes32 indexed key3, bytes value );

}
