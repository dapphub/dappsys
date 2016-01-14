// One singleton factory per dappsys version. 
// Tries to minimize runtime gas cost at the expense of deploy time gas cost.
// Limited by block gas limit. 

contract DSFactory {
    function buildMap() returns (DSMap);
    function buildDSBalanceDB() returns (DSBalanceDB);
    function buildDSApprovalDB() returns (DSApprovalDB);
}
