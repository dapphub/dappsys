// One singleton factory per dappsys version. 
// Tries to minimize runtime gas cost at the expense of deploy time gas cost.
// Limited by block gas limit. 

contract DSFactory {
    function buildDSBalanceDB() returns (DSBalanceDB);
    function buildDSApprovalDB() returns (DSApprovalDB);
    function buildDSTokenController( DSBalanceDB bal_db, DSApprovalDB appr_db )
             returns (DSTokenController);
    function buildDSTokenFrontend( DSTokenController cont ) returns (DSTokenFrontend);
}
