contract DSAuthority {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             constant
             returns (bool);
}
