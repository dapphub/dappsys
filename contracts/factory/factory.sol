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
    function buildDSNullMap() returns (DSNullMap);
    // token
    function buildDSTokenController( DSTokenFrontend frontend, DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController);
    function buildDSTokenFrontend() returns (DSTokenFrontend);
    function buildDSTokenRegistry() returns (DSTokenRegistry);
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

    function buildDSBasicAuthority() returns (DSBasicAuthority ret) {
        ret = _auth.buildDSBasicAuthority();
        setOwner( ret, msg.sender );
    }
    function buildDSBalanceDB() returns (DSBalanceDB ret) {
        ret = _data.buildDSBalanceDB();
        setOwner( ret, msg.sender );
    }
    function buildDSMap() returns (DSMap ret) {
        ret = _data.buildDSMap();
        setOwner( ret, msg.sender );
    }
    function buildDSNullMap() returns (DSNullMap ret) {
        ret = _data.buildDSNullMap();
        setOwner( ret, msg.sender );
    }
    function buildDSApprovalDB() returns (DSApprovalDB ret) {
        ret = _data.buildDSApprovalDB();
        setOwner( ret, msg.sender );
    }
    function buildDSTokenRegistry() returns (DSTokenRegistry ret)
    {
        ret = _token.buildDSTokenRegistry();
        setOwner( ret, msg.sender );
    }
    function buildDSTokenController( DSTokenFrontend frontend, DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController ret)
    {
        ret = _token.buildDSTokenController( frontend, bal_db, appr_db );
        setOwner( ret, msg.sender );
    }
    function buildDSTokenFrontend() returns (DSTokenFrontend ret)
    {
        ret = _token.buildDSTokenFrontend();
        setOwner( ret, msg.sender );
    }
    // @dev Expects to own `authority`
    function installDSTokenBasicSystem( DSBasicAuthority authority )
             returns (DSTokenFrontend frontend )
    {
        setOwner( authority, _token_install );
        frontend = _token_install.installDSTokenBasicSystem( authority );
        setOwner( authority, msg.sender );
        return frontend;
    }
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig ret)
    {
        ret = _ms.buildDSEasyMultisig( n, m, expiration );
        setOwner( ret, msg.sender );
    }
    function() {
        throw;
    }
}
