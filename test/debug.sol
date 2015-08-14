contract Debug {
    // These should be generated for each type
    event logs(bytes val);
    event log_bytes32(bytes32 val);
    event log_bytes8(bytes8 val);
    event log_bytes4(bytes4 val);

    event log_bool(bool val);
    event log_address(address val);

    event log_named_bytes32(bytes32 key, bytes32 val);
    event log_named_bytes8(bytes32 key, bytes8 val);
    event log_named_bytes4(bytes32 key, bytes4 val);
    event log_named_uint(bytes32 key, uint val);
    event log_named_int(bytes32 key, int val);
    event log_named_bool(bytes32 key, bool val);
    event log_named_address(bytes32 key, address val);
}
