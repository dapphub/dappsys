import 'data/balance_db.sol';
import 'factory/factory.sol';
import 'token/controller.sol';
import 'token/deployer.sol';

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
    function buildDSTokenDeployer( DSFactory factory, address owner, uint initial_bal )
             returns (DSTokenDeployer c)
    {
        c = new DSTokenDeployer( factory );
        c.updateAuthority(msg.sender, false);
        c.deploy(owner, initial_bal);
    }
}
