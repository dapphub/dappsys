contract DSAuthFactory {
    function buildDSBasicAuthorityFactory() returns (DSBasicAuthority) {
        var c = new DSBasicAuthority();
        c.updateAuthority(msg.sender, false);
        return c;

    }
}
