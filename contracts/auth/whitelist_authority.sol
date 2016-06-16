import 'auth.sol';

contract DSWhitelistAuthority is DSAuth {
    mapping(address=>bool) _is_whitelisted;
    function canCall(address caller, address code, bytes4 sig) returns (bool) {
        return _is_whitelisted[caller];
    }
    function setIsWhitelisted(address who, bool is_whitelisted)
        auth
    {
        _is_whitelisted[who] = is_whitelisted;
    }
}
