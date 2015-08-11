import "dappsys/asset/baldb/balance_db.sol";
import "dappsys/asset/asset_interface.sol";
import "dappsys/owned.sol";

// Minimal asset that implements DSAssetInterface.
// Can issue one time only.
contract DSBaseAsset is DSAssetInterface, DSOwned {
    bool         public  issuance_locked;
    bool         public  migrated;
    DSBalanceDB  public  db;

    function DSBaseAsset( uint init_balance ) {
        db.add_balance( msg.sender, init_balance );
    }

    // 0x1  issued
    // 0x2  burned
    // 0x3  sent transfer
    // 0x4  received transfer
    event notify( address indexed ho, byte indexed what, uint amount );

    function balances( address who ) returns (uint amount) {
        return db.balances(who);
    }
    function transfer(address to, uint amount) returns (bool success) {
        if( db.balances(msg.sender) < amount ) {
            return false;
        }
        db.sub_balance(msg.sender, amount);
        db.add_balance(to, amount);
        return true;
    }
    function deposit_to(address to, uint amount, bytes32 memo) returns (bool success) {
        if( db.balances(msg.sender) < amount ) {
            return false;
        }
        var acceptor = DSAssetAcceptorInterface(to);
        if( acceptor.request_deposit( to, amount, memo ) ) {
            db.sub_balance(msg.sender, amount);
            db.add_balance(to, amount);
            acceptor.process_deposit( to, amount, memo);
            return true;
        } else {
            return false;
        }
    }
    function burn( uint amount ) returns (bool) {
        if( db.balances(msg.sender) < amount ) {
            return false;
        }
        return db.sub_balance( msg.sender, amount );
    }
    function migrate(DSProtectorInterface new_baldb_owner) auth() {
        if( !migrated ) {
            db._ds_change_protector( new_baldb_owner );
            migrated = true;
        }
    }
}
