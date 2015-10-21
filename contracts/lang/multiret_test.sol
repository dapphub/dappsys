
contract MultiReturner {
    function get() returns (bool ok, bytes value) {
        bytes memory val;
        return (true, val);
    }
}

contract MultiRetUser {
    function try_to_get() {
        var mr = new MultiReturner();
        bytes memory value;
        bool ok;
        (ok, value) = mr.get();
    }
}
