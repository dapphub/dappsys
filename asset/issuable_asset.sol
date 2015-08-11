import "dappsys/asset/base_asset.sol";

contract DSIssuableAsset is DSBaseAsset(0) {
    function issue( address who, uint amount ) auth() returns (bool success) {
        if( issuance_locked ) {
            return false;
        }
        return db.add_balance(who, amount);
    }
    function lock_issuance() auth() {
        issuance_locked = true;
    }

}
