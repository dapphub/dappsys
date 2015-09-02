

contract DSFastPermDB is DSAuthorityInterface {
    mapping( address => mapping( bytes4 => bytes8 ) )    _kern_perm_required;
    mapping( address => bytes8 )                         _kern_perm_grants;
    mapping( address => bytes8 )        public                 _kern_perm_has;

    function set_perms( address who, bytes8 new_perms ) returns (bool) {
        var diff = new_perms ^ _kern_perm_has[who];
        if( subset8(diff, _kern_perm_grants[ msg.sender ]) ) {
            _kern_perm_has[who] = new_perms;
            return true;
        }
        return false;
    }
    function set_grants( address who, bytes8 new_grants ) kern_auth(0x1) returns (bool) {
        _kern_perm_grants[who] = new_grants;
        return true;
    }
    function set_required_perms( address who
                               , bytes4 sig
                               , bytes8 perms ) kern_auth(0x1)
    {
        _kern_perm_required[who][sig] = perms;
    }
    function get_perms( address who ) returns (bytes8) {
        return _kern_perm_has[who];
    }
    function get_required_perms( address who, bytes4 entrypoint ) returns (bytes8) {
        return _kern_perm_required[who][entrypoint];
    }

    // **  Auth
    function can_call( address caller
                     , address callee
                     , bytes4 sig ) returns (bool)
    {
        var has = _kern_perm_has[caller];
        var required = _kern_perm_required[callee][sig];
        if( subset8(has, required) ) {
            return true;
        }
        var alt_required = _kern_perm_required[callee][0x0];
        return subset8(has, alt_required);
    }

    // internal use, not to be confused with *auth() flavors provided
    // by various mixins
    modifier kern_auth(bytes8 required) {
        if( subset8( required, _kern_perm_has[address(this)] ) ) {
            _
        }
    }
 
}
