import "dappsys/control/authority.sol";

contract DSWhitelistAuthority is DSAuthorityInterface {
    mapping( address => bool )  is_root;
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
    }
}
