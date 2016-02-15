import 'auth.sol';
import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'data/nullmap.sol';
import 'data/map.sol';

contract DSDataFactory is DSAuthUser {
    function buildDSBalanceDB() returns (DSBalanceDB ret) {
        ret = new DSBalanceDB();
        returnOwned( ret );
    }
    function buildDSApprovalDB() returns (DSApprovalDB ret) {
        ret = new DSApprovalDB();
        returnOwned( ret );
    }
    function buildDSMap() returns (DSMap ret) {
        ret = new DSMap();
        returnOwned( ret );
    }
    function buildDSNullMap() returns (DSNullMap ret) {
        ret = new DSNullMap();
        returnOwned( ret );
    }
}
