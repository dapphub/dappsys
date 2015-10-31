import 'auth/authority.sol';
import 'auth/auth.sol';

// @brief A DSAuthority which contains a whitelist map from can_call arguments to return value.
contract DSBasicAuthority is DSAuthority
                           , DSAuth
{
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             constant
             returns (bool)
    {
        return _can_call[caller][callee][0x0000] == true
            || _can_call[caller][callee][sig];
    }
    event event_set_can_call( address caller, address callee, bytes4 sig, bool can );
    function set_can_call( address caller
                         , address callee
                         , bytes4 sig
                         , bool can )
             auth()
             returns (bool success)
    {
        _can_call[caller][callee][sig] = can;
        event_set_can_call( caller, callee, sig, can );
        return true;
    }
    function export_authorized( DSAuth who, DSAuthority new_authority )
             auth()
             returns (bool)
    {
        who._ds_update_authority( address(new_authority) );
    }
}
