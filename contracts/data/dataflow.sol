contract DSDataPoint {
    function get(bytes32 key) returns (bytes32);
    function set(bytes32 key) returns (bytes32);
}

contract DSDataSource {
    function get(bytes32 key) returns (bytes32, bool);
    function pull(bytes32 key) returns (bytes32, bool) {
        return get(key);
    }
}
contract DSDataSink {
    function set(bytes32 key, bytes32 val) returns (bool);
    function push(bytes32 key, bytes32 val) returns (bool) {
        return set(key, val);
    }
}

contract DSDataStream is DSDataSink
                       , DSDataSource
{
    
}
