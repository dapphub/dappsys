// TODO rename to authority/interface  ??
contract DSAuthorityInterface {
    function can_call( address caller
                     , address callee
                     , bytes4 sig )
             returns (bool);
}

