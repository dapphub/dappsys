import 'data/balance_db.sol';
import 'asset/interface.sol';

// Contract type for first set of assets
contract DSAsset0Impl is DSAsset0
                       , DSAuth
{
    address _next_version;
    DSBalanceDB public db;
    function DSAsset0Impl() {
        _next_version = address(this);
        db = new DSBalanceDB( address(this) ); // TODO use factory
        db.add_balance( msg.sender, (10**6)*(10**18) );
    }

    function get_balance( address who ) returns (uint balance, bool ok) {
        return db.get_balance( who );
    }
    function transfer( address to, uint amount ) returns (bool success) {
        return db.move_balance( msg.sender, to, amount );
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

    function swap_db( DSBalanceDB db, DSAuthority old_db_owner ) returns (bool success)
    {
        return false;
    }
}
