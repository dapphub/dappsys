contract RejectingAuthority {
    function canCall( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return false;
    }
}


