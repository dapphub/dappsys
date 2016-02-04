// Sets up a token frontend, controller, and databases.
import 'token/controller.sol';
import 'token/frontend.sol';
import 'factory/user.sol';
import 'util/modifiers.sol';
import 'util/false.sol';


contract DSTokenDeployer is DSAuth
                          , DSModifiers
                          , DSFalseFallback
{
    mapping(bytes32=>address) public contracts;
    DSFactory _factory;
    // TODO use constant macro to remove need for constructor arg
    function DSTokenDeployer( DSFactory factory )
    {
        _factory = factory;
    }
    // Specify 0x0 for auth to get a new BasicAuth instance owned by the deployer.
    function deploy( address initial_owner, uint initial_balance, address auth )
             auth()
    {
        var bal_db = _factory.buildDSBalanceDB();
        var appr_db = _factory.buildDSApprovalDB();
        var controller = _factory.buildDSTokenController( bal_db, appr_db );
        var frontend = _factory.buildDSTokenFrontend( controller );
        if( auth == address(0x0) ) {
            var auth = _factory.buildDSBasicAuthority();
        }

        controller.setFrontend( frontend );
    
        bal_db.addBalance( initial_owner, initial_balance );
        bal_db.updateAuthority( address(controller), false );
        appr_db.updateAuthority( address(controller), false );

        controller.updateAuthority( initial_owner, false );
        frontend.updateAuthority( initial_owner, false );


        contracts["auth"] = auth;
        contracts["bal_db"] = bal_db;
        contracts["appr_db"] = appr_db;
        contracts["controller"] = controller;
        contracts["frontend"] = frontend;
    }
    function cleanUp() auth() {
        suicide(msg.sender);
    }
}
