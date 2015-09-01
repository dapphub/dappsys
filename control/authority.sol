contract DSAuthority {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool);
}

contract DSStandardAuthority is DSAuthority {
    function DSStandardAuthority() {
        _is_root[msg.sender] = true;
    }
    mapping(address=>bool)  public _is_root;
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _can_call;
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return _can_call[caller][callee][0x0000] == true
            || _can_call[caller][callee][sig];
    }
    function set_can_call( address caller
                         , address callee
                         , bytes4 sig
                         , bool can )
             root() returns (bool success)
    {
        _can_call[caller][callee][sig] = can;
        return true;
    }
    function set_root( address who, bool status )
             root() returns (bool)
    {
        _is_root[who] = status;
        return true;
    }
    function export_authorized( DSAuth who
                              , DSAuthority new_authority
                              , byte mode )
             root()
             returns (bool)
    {
        who._ds_set_authority( new_authority, mode );
    }
    modifier root() {
        if( _is_root[msg.sender] ) {
            _
        }
    }

}
