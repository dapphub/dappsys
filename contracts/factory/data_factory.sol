import 'auth.sol';
import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'data/map.sol';

contract DSDataFactory {
    function buildDSBalanceDB() returns (DSBalanceDB) {
        var c = new DSBalanceDB();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
        return c;
    }
    function buildDSApprovalDB() returns (DSApprovalDB) {
        var c = new DSApprovalDB();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
        return c;
    }
    function buildDSMap() returns (DSMap) {
        var c = new DSMap();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
        return c;
    }
}
