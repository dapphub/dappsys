contract DSTokenEventCallback {
    function emitTransfer( address from, address to, uint amount );
    function emitApproval( address holder, address spender, uint amount );
}
