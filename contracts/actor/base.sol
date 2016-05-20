contract DSActionStructUser {
    struct Action {
        address target;
        uint value;
        bytes calldata;
        // bool triggered;
    }
    // todo store call_ret by default?
}
// A base contract used by governance contracts in `gov` and by the generic `DSController`.
contract DSBaseActor is DSActionStructUser {
    // todo gas???
    function tryExec(Action a) internal returns (bool call_ret) {
        return a.target.call.value(a.value)(a.calldata);
    }
    function exec(Action a) internal {
        if(!tryExec(a)) {
            throw;
        }
    }
    function tryExec( address target, bytes calldata, uint value)
             internal
             returns (bool call_ret)
    {
        return target.call.value(value)(calldata);
    }
    function exec( address target, bytes calldata, uint value)
             internal
    {
        if(!tryExec(target, calldata, value)) {
            throw;
        }
    }
}
