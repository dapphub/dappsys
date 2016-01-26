contract DSTokenEventCallback {
    function eventTransfer( address from, address to, uint amount ) returns (bool);
    function eventApproval( address holder, address spender, uint amount ) returns (bool);
}
