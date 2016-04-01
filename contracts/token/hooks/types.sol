// Sub-actions to be run on stateful token function calls
contract DSTokenSystemTransferHookType {
    function transfer( address _frontend_caller, address to, uint value ) returns (bool ok);
}
contract DSTokenSystemTransferFromHookType {
    function transferFrom( address _frontend_caller, address from, address to, uint value ) returns (bool ok);
}
contract DSTokenSystemApproveHookType {
    function approve( address _frontend_caller, address to, uint value ) returns (bool ok);
}
