// Sets up a token frontend, controller, and databases.
import 'auth/basic_authority.sol';
import 'token/controller.sol';
import 'token/frontend.sol';
import 'factory/factory.sol';
import 'factory/user.sol';
import 'util/modifiers.sol';
import 'util/false.sol';


contract DSTokenDeployer is DSAuth
                          , DSFalseFallback
{
    DSFactory _factory;
    // TODO use constant macro to remove need for constructor arg ?
    function DSTokenDeployer( DSFactory factory )
    {
        _factory = factory;
    }

    // `authority` is a `DSBasicAuthority` this contract needs direct-ownership
    // of. It will hand ownership back to the parent after deploying.
    // If you specify address 0x0, deploy will build a new BasicAuthority.
    function deploy( DSBasicAuthority authority, address initial_balance_owner, uint initial_balance )
             auth()
             returns( DSTokenFrontend token_frontend, DSBasicAuthority new_authority )
    {
        if( authority == address(0x0) ) {
            authority = _factory.buildDSBasicAuthority();
        } else {
            if(  authority._authority() != address(this) || authority._auth_mode() != false )
            {
                throw;
            }
        }
        var balance_db = _factory.buildDSBalanceDB();
        var approval_db = _factory.buildDSApprovalDB();
        var controller = _factory.buildDSTokenController( balance_db, approval_db );
        var frontend = _factory.buildDSTokenFrontend( controller );

        controller.setFrontend( frontend );

        balance_db.addBalance( initial_balance_owner, initial_balance );

        balance_db.updateAuthority( authority, true );
        approval_db.updateAuthority( authority, true );
        controller.updateAuthority( authority, true );
        frontend.updateAuthority( authority, true );

        // The only data ops the controller does is `move` balances and `set` approvals.
        authority.setCanCall( controller, balance_db, bytes4(sha3("moveBalance(address,address,uint256)")), true );
        authority.setCanCall( controller, approval_db, bytes4(sha3("set(address,address,uint256)")), true );

        // The controller calls back to the forntend for 3 events.
        authority.setCanCall( controller, frontend, bytes4(sha3("eventTransfer(address,address,uint256)")), true );
        authority.setCanCall( controller, frontend, bytes4(sha3("eventTransferFrom(address,address,uint256)")), true );
        authority.setCanCall( controller, frontend, bytes4(sha3("eventApproval(address,address,uint256)")), true );

        // The frontend can call the proxy functions.
        authority.setCanCall( frontend, controller, bytes4(sha3("transfer(address,address,uint256)")), true );
        authority.setCanCall( frontend, controller, bytes4(sha3("transferFrom(address,address,address,uint256)")), true );
        authority.setCanCall( frontend, controller, bytes4(sha3("approve(address,address,uint256)")), true );

        authority.updateAuthority(msg.sender, false);

        return (frontend, authority);
    }
    function kill() auth() {
        suicide(msg.sender);
    }
}
