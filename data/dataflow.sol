contract DSDataInStream {
    // might require computation
    function pull() returns (bytes32);
}
contract DSDataOutStream {
    function push(bytes32 val);
}

contract DSDataSource is DSDataInStream {
    // definitely doesn't require computation
    function get() returns (bytes32);
    function pull() returns (bytes32) {
        return get();
    }
}
contract DSDataSink is DSDataOutStream {
    function set(bytes32 val);
    function push(bytes32 val) {
        set(val);
    }
}


contract DSData
