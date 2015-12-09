import 'auth/authority.sol';
import 'auth/auth.sol';

// A `DSAuthority` which contains a whitelist map from can_call arguments to return value.
// WARNING: The signature `0x0` is reserved to mean the caller is whitelisted for ALL signatures
// on the callee.
// Note it is itself a `DSAuth` - ie it is not self-authorized by default.
contract DSBasicAuthority is DSAuthority
                           , DSAuth
{
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;
    // See `DSAuthority.sol`
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return _can_call[caller][callee][0x0000] == true
            || _can_call[caller][callee][sig];
    }
    event Updated( address caller, address callee, bytes4 sig, bool can );
    function set_can_call( address caller
                         , address callee
                         , bytes4 sig
                         , bool can )
             auth()
             returns (bool success)
    {
        _can_call[caller][callee][sig] = can;
        Updated( caller, callee, sig, can );
        return true;
    }
    // Be sure you set the correct mode.
    function export_authorized( DSAuth who, address new_authority, uint8 mode )
             auth()
             returns (bool)
    {
        return who._ds_update_authority( address(new_authority), mode );
    }
}
