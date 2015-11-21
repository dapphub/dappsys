contract RejectingAuthority {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool)
    {
        return false;
    }
}


