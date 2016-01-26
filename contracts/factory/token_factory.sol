import 'data/balance_db.sol';
import 'token/controller.sol';

contract DSTokenFactory {
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
}
