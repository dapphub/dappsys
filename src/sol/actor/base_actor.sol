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
            gas = msg.gas;
        }
        return target.call.value(value).gas(gas)(calldata);
    }
}

// Simple example and passthrough for testing
contract DSSimpleActor is DSBaseActor {
    function execute( address target, bytes calldata, uint value, uint gas )
             returns (bool call_ret )
    {
        return exec( target, calldata, value, gas );
    }
}


