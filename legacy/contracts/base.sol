contract DSBase {
    function assert(bool condition) internal {
        if (!condition) throw;
    }

    function throws(bytes32 reason) internal {
        log1(msg.sig, reason);
        throw;
    }

    // TODO: eventually you'll be able to override fallbacks
    function () {
        throw;
    }
}
