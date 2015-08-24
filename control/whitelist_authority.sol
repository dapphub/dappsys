import "dappsys/control/authority.sol";

contract DSWhitelistAuthority is DSAuthorityInterface {
    function DSWhitelistAuthority() {
        _is_root[msg.sender] = true;
    }
    mapping(address=>bool)  public _is_root;
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        if( _can_call[caller][callee][0x0000] == true ) {
            return true;
        }
        return _can_call[caller][callee][sig];
    }
    modifier root() {
        if( _is_root[msg.sender] ) {
            _
        }
    }
    function set_can_call( address caller
                         , address callee
                         , bytes3 sig
                         , bool can )
             root()
             returns (bool success)
    {
        _can_call[caller][callee][sig] = can;
        return true;
    }
    function set_is_root( address who
                        , bool what )
             root()
             returns (bool success)
    {
        _is_root[who] = what;
        return true;
    }
}
