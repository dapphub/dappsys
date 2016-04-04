// A base contract mostly used by governance contracts in `gov`.
// For now, this just means the multisig contract, but it could
// be used for stake-vote or futarchy.
contract DSBaseActor {
    // return result of `call` keyword
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

