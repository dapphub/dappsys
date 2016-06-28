contract DSBase {
    function assert(bool what)
        internal
    {
        if (NOT(what)) {
            throw;
        }
    }
    function NOT(bool what)
        internal
        constant
        returns (bool)
    {
        return !what;
    }
    function throws(bytes32 reason)
        internal
    {
        log1(msg.sig, reason);
        throw;
    }
    // eventually you'll be able to override fallbacks
    function() {
        throw;
    }
}
