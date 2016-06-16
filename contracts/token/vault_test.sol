import 'dapple/test.sol';

import 'token/base.sol';
import 'token/vault.sol';

import 'auth.sol';

contract DSTokenVaultTest is Test, DSAuthUser {
    DSToken token;
    DSTokenVault vault;
    function setUp() {
        token = new DSTokenBase(10**18);
        vault = new DSTokenVault();
        token.transfer(vault, 10**18);
    }
    function testTransferIfAuthed() {
        assertEq(0, token.balanceOf(this));
        vault.transfer(token, this, 10**18);
        assertEq(10**18, token.balanceOf(this));
    }
    function testFailNoTransferIfNotAuthed() {
        assertEq(0, token.balanceOf(this));
        vault.updateAuthority(address(0x0), DSAuthModes.Owner);
        vault.transfer(token, this, 10**18);
        assertEq(10**18, token.balanceOf(this));
    }
}
