import "dappsys/asset/base_asset.sol";

contract DSIssuableAsset is DSBaseAsset(0) {
    function issue( address who, uint amount ) ds_owner() returns (bool success) {
        if( issuance_locked ) {
            return false;
        }
        return db.add_balance(who, amount);
    }
    function lock_issuance() ds_owner() {
        issuance_locked = true;
    }

}
