// A base contract mostly used by governance contracts in `gov`.
// For now, this just means the multisig contract, but it could
// be used for stake-vote or futarchy.
contract DSBaseActor {
    function exec( address target, bytes calldata, uint value, uint gas)
             internal
             returns (bool call_ret)
    {
        // 0 is never a reasonable gas amount, so it's a magic value for "all the gas"
        if( gas == 0 ) {
            return target.call.value(value)(calldata);
        } else {
            return target.call.value(value).gas(gas)(calldata);
        }
    }
}

