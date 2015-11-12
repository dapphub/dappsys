import 'data/balance_db.sol';
import 'asset/interface.sol';

// Contract type for first set of assets
contract DSAsset0Impl is DSAsset0
                       , DSAuth
{
    DSBalanceDB public db;
    function DSAsset0Impl( address balance_db ) {
        db = DSBalanceDB(balance_db);
    }
    function get_supply() constant returns (uint, bool) {
        return db.get_supply();
    }
    function get_balance( address who ) constant returns (uint balance, bool ok) {
        return db.get_balance( who );
    }
    function transfer( address to, uint amount ) returns (bool success) {
        return transfer_and_notify( to, amount, 0x0 );
    }
    function transfer_and_notify( address to
                                , uint amount
                                , bytes32 data )
             returns (bool success)
    {
        success = db.move_balance( msg.sender, to, amount );
        if( success ) {
            event_transfer_and_notify( msg.sender, to, data, amount );
        }
        return success;
    }

    function swap_db( DSBalanceDB new_db, DSAuthority old_db_new_owner, uint8 mode )
             auth()
             returns (bool success)
    {
        var ok = db._ds_update_authority( old_db_new_owner );
        if( ok ) {
            db = new_db;
            event_swap_db( address(db), address(old_db_new_owner) );
            return true;
        }
        return false;
    }
}
