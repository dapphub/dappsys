import 'auth.sol';
import 'auth/basic_authority.sol';
import 'data/balance_db.sol';
import 'factory/data_factory.sol';
import 'factory/auth_factory.sol';
import 'token/controller.sol';
import 'token/base.sol';
import 'token/frontend.sol';
import 'token/registry.sol';

contract DSTokenFactory is DSAuthUser {
    function buildDSTokenController( DSTokenFrontend frontend, DSBalanceDB bal_db, DSApprovalDB appr_db )
             external
             returns (DSTokenController ret)
    {
        ret = new DSTokenController( frontend, bal_db, appr_db );
        setOwner( ret, msg.sender );
    }
    function buildDSTokenFrontend()
             external
             returns (DSTokenFrontend ret)
    {
        ret = new DSTokenFrontend();
        setOwner( ret, msg.sender );
    }
    function buildDSTokenRegistry()
             returns (DSTokenRegistry ret)
    {
        ret = new DSTokenRegistry();
        setOwner( ret, msg.sender );
    }
}

contract DSTokenInstaller is DSAuthUser {
    DSTokenFactory _token;
    DSDataFactory _data;
    DSAuthFactory _auth;
    function DSTokenInstaller( DSAuthFactory auth, DSDataFactory data, DSTokenFactory token ) {
        _auth = auth;
        _data = data;
        _token = token;
    }
    // @dev Precondition: authority._authority() == address(this) && authority._auth_mode() == false;
    //      Postcondition:  authority._authority() == msg.sender && authority._auth_mode() == false;
    function installDSTokenBasicSystem( DSBasicAuthority authority )
             returns( DSTokenFrontend frontend )
    {
        frontend = _token.buildDSTokenFrontend();
        var balance_db = _data.buildDSBalanceDB();
        var approval_db = _data.buildDSApprovalDB();
        var controller = _token.buildDSTokenController( frontend, balance_db, approval_db );

        frontend.setController( controller );

        setAuthority( balance_db, authority );
        setAuthority( approval_db, authority );
        setAuthority( controller, authority );
        setAuthority( frontend, authority );

        // The only data ops the controller does is `move` balances and `set` approvals.
        authority.setCanCall( controller, balance_db, "moveBalance(address,address,uint256)", true );
        authority.setCanCall( controller, approval_db, "setApproval(address,address,uint256)", true );

        // The controller calls back to the forntend for the 2 events.
        authority.setCanCall( controller, frontend, "emitTransfer(address,address,uint256)", true );
        authority.setCanCall( controller, frontend, "emitApproval(address,address,uint256)", true );

        // The frontend can call the proxy functions.
        authority.setCanCall( frontend, controller, "transfer(address,address,uint256)", true );
        authority.setCanCall( frontend, controller, "transferFrom(address,address,address,uint256)", true );
        authority.setCanCall( frontend, controller, "approve(address,address,uint256)", true );

        setOwner( authority, msg.sender);
        return frontend;
    }
}

contract DSTokenInstallerMorden is DSTokenInstaller (
    DSAuthFactory(0x068a602cd168f59d61ae514a6807467480327786)
  , DSDataFactory(0x05ebf0e9e5db6c1f524c2e6e2078fcdbc1ebe123)
  , DSTokenFactory(0x3e7dd3254b2f64d04634ad31a369d7a84e7c424a)
) {}
