contract Thrower {
    event Error(bytes4 indexed errtype, string message);
    function throws(string message) internal {
        throws(msg.sig, message);
    }
    function throws(bytes4 etype, string message) internal {
        Error(etype, message);
        throw;
    }
}
