import 'auth/authority.sol';

contract RejectingAuthority is DSAuthority {
    function canCall( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return false;
    }
}


