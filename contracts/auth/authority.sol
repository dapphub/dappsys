import 'util/true.sol';
import 'util/false.sol';


// Use `DSAuthority` from `auth.sol` instead of using this type directly.
contract DSAuthorityInterface {
    // `can_call` will be called with these arguments in the caller's
    // scope if it is coming from an `auth()` call:
    // `DSAuthority(_ds_authority).can_call(msg.sender, address(this), msg.sig);`
    function canCall( address caller
                    , address callee
                    , bytes4 sig )
             constant
             returns (bool);
}


contract AcceptingAuthority is DSTrueFallback {}
contract RejectingAuthority is DSFalseFallback {}
