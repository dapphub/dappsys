contract DSAsset0 // is DSAuth
{
    function get_supply() constant returns (uint balance, bool ok);
    function get_balance( address who ) constant returns (uint balance, bool ok);

    // limited functionality that is good for traditional exchanges
    // that don't use contract-based wallets yet.
    function transfer( address to, uint amount ) returns (bool success);
    function transfer_and_notify( address to
                                , uint amount
                                , bytes32 data )
             returns (bool success);
    event event_transfer_and_notify( address indexed from
                                   , address indexed to
                                   , bytes32 indexed data
                                   , uint amount);

    // Admin
    function swap_db( DSBalanceDB db, DSAuthority old_db_new_owner ) returns (bool success);
    event event_swap_db( address db, address old_db_new_owner );
}





contract AssetPatterns {

    // The basic asset pipeline tool. Explicitly passes permission
    // to take control of the asset from sender to receipient.
    //function approve( address who, uint amount ) returns (bool ok);
    //function transfer_from( address who, address to, uint amount) returns (bool ok);

    // increase approved amount for everyone in this transaction
    //function withdraw
    // take this much from the transaction
    //function charge
    
}
