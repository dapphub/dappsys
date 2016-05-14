// Locks a single `setCanCall` result permanently.

contract DSAuthorityLock is DSAuthority, DSAuth {
    DSAuthority subauthority;
    struct Entry {
        bool can_call;
        bool locked;
    }
    mapping(address=>mapping(address=>mapping(bytes4=>bool))) _entries;
    function canCall(address caller, address code, bytes4 sig) returns (bool) {
        var entry = _entries[caller][code][sig];
        if (entry.locked) {
            return entry.can_call;
        } else {
            return subauthority.canCall(
        }
    }
    function lock(address caller, address code, bytes4 sig, bool enabled)
        auth()
    {
        var entry = _entries[caller][code][sig];
        if (entry.locked) {
            throw;
        }
        entry.can_call = enabled;
        entry.locked = true;
    }
}
