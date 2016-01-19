import 'auth/basic_authority.sol';
import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'gov/easy_multisig.sol';
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
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController);
    function buildDSTokenFrontend( DSTokenController cont ) returns (DSTokenFrontend);
    // gov
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig);
}
contract DSFactory1 is DSFactory {
    DSDataFactory _data;
    DSTokenFactory _token;
    DSMultisigFactory _ms;
    DSAuthFactory _auth;
    function DSFactory1( DSDataFactory data
                       , DSTokenFactory token
                       , DSMultisigFactory ms
                       , DSAuthFactory auth )
    {
        _data = data;
        _token = token;
        _ms = ms;
        _auth = auth;
    }

    function buildDSBasicAuthority() returns (DSBasicAuthority c) {
        c = _auth.buildDSBasicAuthority();
        c.updateAuthority(msg.sender, false);
    }
    function buildDSBalanceDB() returns (DSBalanceDB c) {
        c = _data.buildDSBalanceDB();
        c.updateAuthority(msg.sender, false);
    }
    function buildDSMap() returns (DSMap c) {
        c = _data.buildDSMap();
        c.updateAuthority(msg.sender, false);
    }
    function buildDSApprovalDB() returns (DSApprovalDB c) {
        c = _data.buildDSApprovalDB();
        c.updateAuthority(msg.sender, false);
    }
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController c)
    {
        c = _token.buildDSTokenController( bal_db, appr_db );
        c.updateAuthority(msg.sender, false);
    }
    function buildDSTokenFrontend( DSTokenController cont ) returns (DSTokenFrontend c)
    {
        c = _token.buildDSTokenFrontend( cont );
        c.updateAuthority(msg.sender, false);
    }
    function buildDSEasyMultisig( uint n, uint m, uint expiration ) returns (DSEasyMultisig)
    {
        var c = _ms.buildDSEasyMultisig( n, m, expiration );
        c.updateAuthority(msg.sender, false);
        return c;
    }
    function() returns (bytes32) {
        return 0x0;
    }
}


// If you need the latest factory in assembled form for a private
// chain or VM tests.
contract DSFactoryTestFactory {
    function buildFactory() returns (DSFactory) {
        var data = new DSDataFactory();
        var token = new DSTokenFactory();
        var ms = new DSMultisigFactory();
        var auth = new DSAuthFactory();
        var f = new DSFactory1(data, token, ms, auth);
        return f;
    }
}


