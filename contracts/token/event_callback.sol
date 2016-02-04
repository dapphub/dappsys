contract DSTokenEventCallback {
    function eventTransfer( address from, address to, uint amount );
    function eventApproval( address holder, address spender, uint amount );
}
