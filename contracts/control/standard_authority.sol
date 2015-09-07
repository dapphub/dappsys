import 'dappsys/control/authority.sol';
import 'dappsys/control/auth.sol';

contract DSStandardAuthority is DSAuthority
                              , DSAuth
{
    function DSStandardAuthority() {
        _is_root[msg.sender] = true;
    }
    mapping(address=>bool)  public _is_root;
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
    event set_can_call_event( address caller, address callee, bytes4 sig, bool can );
    function set_can_call( address caller
                         , address callee
                         , bytes4 sig
                         , bool can )
             auth()
             returns (bool success)
    {
        _can_call[caller][callee][sig] = can;
        set_can_call_event( caller, callee, sig, can );
        return true;
    }
    event set_root_event( address who, bool is_root );
    function set_root( address who, bool is_root )
             auth()
             returns (bool)
    {
        _is_root[who] = is_root;
        set_root_event( who, is_root );
        return true;
    }
    function export_authorized( DSAuth who
                              , DSAuthority new_authority
                              , byte mode )
             auth()
             returns (bool)
    {
        who._ds_set_authority( new_authority, mode );
    }
}
