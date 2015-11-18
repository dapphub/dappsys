// This interface is a minimum viable asset controller.
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
    function swap_db( DSBalanceDB db, DSAuthority old_db_new_owner, uint8 mode ) returns (bool success);
    event event_swap_db( address db, address old_db_new_owner );
}

// This interface adds small set of functions for contract-based asset manipulation.
// It is a subset of old the MakerAsset and the proposed standard asset API in the ethereum wiki.
contract DSAsset1 // is DSAuth
{
    function transfer( address to, uint amount) returns (bool ok);
    function transfer_and_notify( address to
                                , uint amount
                                , bytes32 data );
    function transfer_and_notify( address from
                                , address to
                                , uint amount
                                , bytes32 data );
    function transferFrom( address from, address to, uint amount ) returns (bool ok);
    function balanceOf( address who ) constant returns (uint amount, bool ok);

    event event_transfer_and_notify( address indexed from
                                   , address indexed to
                                   , bytes32 indexed data
                                   , uint amount);




    function approve( address who ) returns (bool ok);
    function unapprove( address who ) returns (bool ok);
    function isApprovedFor( address holder, address spender ) constant returns (bool approved, bool ok);

    event event_updated_approval( address indexed holder, address indexed spender, bool indexed can_spend );
}
