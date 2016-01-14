// Sets up a token frontend, controller, and databases.
import 'data/approval_db.sol';
import 'data/balance_db.sol';
import 'token/controller.sol';
import 'token/frontend.sol';
import 'util/modifiers.sol';
import 'util/false.sol';

contract DSTokenDeployerFactory {
    DSBalanceDBFactory _balance_factory;
    DSApprovalDBFactory _approval_factory;
    function DSTokenDeployerFactory( DSBalanceDBFactory balance_factory
                                   , DSApprovalDBFactory approval_factory)
    {
        _balance_factory = balance_factory;
        _approval_factory = approval_factory;
    }
    function build() returns (DSTokenDeployer) {
        var dep = new DSTokenDeployer(_balance_factory, _approval_factory);
        dep.updateAuthority(msg.sender, true);
        return dep;
    }
}

contract DSTokenDeployer is DSAuth
                          , DSModifiers
                          , DSFalseFallback
{
    mapping(bytes32=>address) public contracts;
    DSBalanceDBFactory _bal_factory;
    DSApprovalDBFactory _appr_factory;
    // TODO(v2) optionally accept factories as arguments.
    function DSTokenDeployer( DSBalanceDBFactory bal_factory, DSApprovalDBFactory appr_factory)
    {
        _bal_factory = bal_factory;
        _appr_factory = appr_factory;
    }
    function deploy( address initial_owner, uint initial_balance )
             auth()
    {
        var bal_db = _bal_factory.build();
        var appr_db = _appr_factory.build();
        var controller = new DSTokenController(bal_db, appr_db);
        var frontend = new DSTokenFrontend( controller );

        controller.setFrontend( frontend );
    
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
