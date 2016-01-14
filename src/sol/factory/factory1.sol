import 'factory/factory.sol';

import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'data/map.sol';

import 'token/frontend.sol';
import 'token/controller.sol';

contract DSFactory1 is DSFactory {
    function buildDSBalanceDB() returns (DSBalanceDB) {
        var c = new DSBalanceDB();
        c.updateAuthority(msg.sender, false);
        return c;
    }
    function buildDSApprovalDB() returns (DSApprovalDB) {
        var c = new DSApprovalDB();
        c.updateAuthority(msg.sender, false);
        return c;
    }
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController)
    {
        var c = new DSTokenController( bal_db, appr_db );
        c.updateAuthority(msg.sender, false);
        return c;
    }
    function buildDSTokenFrontend( DSTokenController cont ) returns (DSTokenFrontend) {
        var c = new DSTokenFrontend( cont );
        c.updateAuthority(msg.sender, false);
        return c;
    }
/*
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig) {
        var c = new DSEasyMultisig( n, m, expiration );
    }
*/
}
