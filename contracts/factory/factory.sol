import 'auth.sol';
import 'auth/basic_authority.sol';
import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'gov/easy_multisig.sol';
import 'token/base.sol';
import 'token/controller.sol';
import 'token/frontend.sol';

import 'factory/auth_factory.sol';
import 'factory/data_factory.sol';
import 'factory/token_factory.sol';
import 'factory/multisig_factory.sol';


// One singleton factory per dappsys version.
// Motivated by and limited by block gas limit.

contract DSFactory {
    // auth
    function buildDSBasicAuthority() returns (DSBasicAuthority);
    // data
    function buildDSBalanceDB() returns (DSBalanceDB);
    function buildDSApprovalDB() returns (DSApprovalDB);
    function buildDSMap() returns (DSMap);
    // token
    function buildDSTokenController( DSTokenFrontend frontend, DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController);
    function buildDSTokenFrontend() returns (DSTokenFrontend);
    function installDSTokenBasicSystem( DSBasicAuthority authority ) 
             returns( DSTokenFrontend token_frontend );
    // gov
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig);
}
contract DSFactory1 is DSFactory, DSAuthUser {
    DSDataFactory _data;
    DSTokenFactory _token;
    DSMultisigFactory _ms;
    DSAuthFactory _auth;
    DSTokenInstaller _token_install;

    function DSFactory1( DSAuthFactory auth
                       , DSDataFactory data
                       , DSMultisigFactory ms
                       , DSTokenFactory token
                       , DSTokenInstaller token_install )
    {
        _auth = auth;
        _data = data;
        _token = token;
        _ms = ms;
        _token_install = token_install;
    }

    function buildDSBasicAuthority() returns (DSBasicAuthority c) {
        c = _auth.buildDSBasicAuthority();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
    }
    function buildDSBalanceDB() returns (DSBalanceDB c) {
        c = _data.buildDSBalanceDB();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
    }
    function buildDSMap() returns (DSMap c) {
        c = _data.buildDSMap();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
    }
    function buildDSApprovalDB() returns (DSApprovalDB c) {
        c = _data.buildDSApprovalDB();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
    }
    function buildDSTokenController( DSTokenFrontend frontend, DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController c)
    {
        c = _token.buildDSTokenController( frontend, bal_db, appr_db );
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
    }

    // TODO document pre/post conditions
    function installDSTokenBasicSystem( DSBasicAuthority authority )
             returns (DSTokenFrontend frontend )
    {
        authority.updateAuthority(_token, DSAuthModes.Owner);
        frontend = _token_install.installDSTokenBasicSystem( authority );
        authority.updateAuthority( msg.sender, DSAuthModes.Owner );
        return frontend;
    }
    function buildDSTokenFrontend() returns (DSTokenFrontend c)
    {
        c = _token.buildDSTokenFrontend();
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
        return c;
    }
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig)
    {
        var c = _ms.buildDSEasyMultisig( n, m, expiration );
        c.updateAuthority(msg.sender, DSAuthModes.Owner);
        return c;
    }
    function() returns (bytes32) {
        return 0x0;
    }
}

