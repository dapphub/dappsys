// Sets up a token frontend, controller, and databases.
import 'data/approval_db.sol';
import 'data/balance_db.sol';
import 'token/controller.sol';
import 'token/frontend.sol';
import 'util/modifiers.sol';
import 'util/false.sol';

// cleanUp, only_once
contract DSTokenDeployer is DSAuth
                          , DSModifiers
                          , DSFalseFallback
{
    mapping(bytes32=>address) public contracts;
    // TODO(v2) optionally accept factories as arguments.
    function DSTokenDeployer() {
    }
    function deploy( address initial_owner, uint initial_balance )
             auth()
    {
        var bal_db = new DSBalanceDB();
        var appr_db = new DSApprovalDB();
        var controller = new DSTokenController(bal_db, appr_db);
        var frontend = new DSTokenFrontend( controller );

        controller.setProxy( frontend );
    
        bal_db.addBalance( initial_owner, initial_balance );
        bal_db.updateAuthority( address(controller), false );
        appr_db.updateAuthority( address(controller), false );

        controller.updateAuthority( initial_owner, false );
        frontend.updateAuthority( initial_owner, false );

        contracts["bal_db"] = bal_db;
        contracts["appr_db"] = appr_db;
        contracts["controller"] = controller;
        contracts["frontend"] = frontend;
    }
    function cleanUp() auth() {
        suicide(msg.sender);
    }
}
