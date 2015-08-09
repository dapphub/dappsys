contract DSOwned {
    address public __ds_owner;
    function DSOwned() {
        __ds_owner = msg.sender;
    }
    modifier ds_owner() {
        if( msg.sender == __ds_owner ) {
            _
        }
    }
    function _ds_transfer_ownership( address to ) ds_owner() {
        __ds_owner = to;
    }
    function _ds_kill() ds_owner() {
        suicide(__ds_owner);
    }
}

/*
contract DSOwnedMultiOwned is DSOwned {
    mapping( address => bool ) _ds_owners;
    uint  _ds_owner_count;
    function DSOwned() {
        _ds_owners[msg.sender] = true;
        _ds_owner_count = 1;
    }
    function is_owner( address who ) returns (bool) {
        return _ds_owners[who];
    }
    function has_owners() returns (bool) {
        return (_ds_owner_count > 0);
    }
    function set_owner( address who, bool set_to ) _ds_owner_only {
        if( set_to && !_ds_owners[who]) {
            _ds_owner_count++;
        }
        if( !set_to && _ds_owners[who]) {
            _ds_owner_count--;
        }
        _ds_owners[who] = set_to;
    }
}
*/
