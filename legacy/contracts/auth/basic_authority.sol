import 'auth.sol';

contract DSBasicAuthorityEvents {
    event DSSetCanCall( address caller_address
                      , address code_address
                      , bytes4 sig
                      , bool can );
}

// A `DSAuthority` which contains a whitelist map from can_call arguments to return value.
// Note it is itself a `DSAuth` - ie it is not self-authorized by default.
contract DSBasicAuthority is DSAuthority
                           , DSBasicAuthorityEvents
                           , DSAuth
{
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;

    // See `DSAuthority.sol`
    function canCall( address caller_address
                    , address code_address
                    , bytes4 sig )
             constant
             returns (bool)
    {
        return _can_call[caller_address][code_address][sig];
    }

    function setCanCall( address caller_address
                       , address code_address
                       , bytes4 sig
                       , bool can )
             auth()
    {
        _can_call[caller_address][code_address][sig] = can;
        DSSetCanCall( caller_address, code_address, sig, can );
    }

    function setCanCall( address caller_address
                       , address code_address
                       , string signature
                       , bool can )
             auth()
    {
        var sig = bytes4(sha3(signature));
        _can_call[caller_address][code_address][sig] = can;
        DSSetCanCall( caller_address, code_address, sig, can );
    }

}
