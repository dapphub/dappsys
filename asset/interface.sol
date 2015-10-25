contract DSAsset0
{

    // part of util mixin?
    event metadata( uint indexed version, bytes sol_abi_hash, bytes web_ui_hash );
    function swap_db( DSBalanceDB db, DSAuthority old_db_owner ) returns (bool success);
    //


    function get_balance( address who ) returns (uint balance, bool ok);
    function transfer( address to, uint amount ) returns (bool success);
    // limited functionality that is good for traditional exchanges
    // that don't use contract-based wallets yet.
    function transfer_and_notify( address to
                                , uint amount
                                , bytes32 data )
             returns (bool success);
    event event_transfer_and_notify( address indexed from
                                   , address indexed to
                                   , bytes32 indexed data
                                   , uint amount);

    // The basic asset pipeline tool. Explicitly passes permission
    // to take control of the asset from sender to receipient.
    //function approve( address who, uint amount ) returns (bool ok);
    //function transfer_from( address who, address to, uint amount) returns (bool ok);

    // increase approved amount for everyone in this transaction
    //function withdraw
    // take this much from the transaction
    //function charge
    
    //function set_controller( address who ) ret



    // success events


    // extra events
}


