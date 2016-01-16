import 'data/balance_db.sol';
import 'data/approval_db.sol';
import 'gov/easy_multisig.sol';
import 'token/controller.sol';
import 'token/frontend.sol';

import 'factory/data_factory.sol';
import 'factory/token_factory.sol';
import 'factory/multisig_factory.sol';


// One singleton factory per dappsys version. 
// Motivated by and limited by block gas limit. 

contract DSFactory {
    function buildDSBalanceDB() returns (DSBalanceDB);
    function buildDSApprovalDB() returns (DSApprovalDB);
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController);
    function buildDSTokenFrontend( DSTokenController cont ) returns (DSTokenFrontend);
}
contract DSFactory1 is DSFactory {
    DSDataFactory _data;
    DSTokenFactory _token;
    DSMultisigFactory _ms;
    function DSFactory1( DSDataFactory data
                       , DSTokenFactory token
                       , DSMultisigFactory ms )
    {
        _data = data;
        _token = token;
        _ms = ms;
    }

    function buildDSBalanceDB() returns (DSBalanceDB) {
        return _data.buildDSBalanceDB();
    }
    function buildDSApprovalDB() returns (DSApprovalDB) {
        return _data.buildDSApprovalDB();
    }
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController)
    {
        return _token.buildDSTokenController( bal_db, appr_db );
    }
    function buildDSTokenFrontend( DSTokenController cont ) returns (DSTokenFrontend)
    {
        return _token.buildDSTokenFrontend( cont );
    }
}


// If you need the latest factory in assembled form for a private
// chain or VM tests.
contract DSFactoryTestFactory {
    function buildFactory() returns (DSFactory) {
        var data = new DSDataFactory();
        var token = new DSTokenFactory();
        var ms = new DSMultisigFactory();
        var f = new DSFactory1(data, token, ms);
        return f;
    }
}


