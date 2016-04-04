import 'auth.sol';
import 'data.sol';

contract DSDataFactory is DSAuthUser {
    function buildDSBalanceDB() returns (DSBalanceDB ret) {
        ret = new DSBalanceDB();
        setOwner( ret, msg.sender );
    }
    function buildDSApprovalDB() returns (DSApprovalDB ret) {
        ret = new DSApprovalDB();
        setOwner( ret, msg.sender );
    }
    function buildDSMap() returns (DSMap ret) {
        ret = new DSMap();
        setOwner( ret, msg.sender );
    }
    function buildDSNullMap() returns (DSNullMap ret) {
        ret = new DSNullMap();
        setOwner( ret, msg.sender );
    }
}
