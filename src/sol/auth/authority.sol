// `DSAuthority` is the interface which `DSAuth` contracts expect
// their authority to be when they are in the remote auth mode.
contract DSAuthority {
    // `can_call` will be called with these arguments in the caller's
    // scope if it is coming from an `auth()` call:
    // `DSAuthority(_ds_authority).can_call(msg.sender, address(this), msg.sig);`
    function canCall( address caller
                    , address callee
                    , bytes4 sig )
             returns (bool);
}
