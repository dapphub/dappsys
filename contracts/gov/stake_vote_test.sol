import 'dapple/test.sol';

import 'gov/stake_vote_model.sol';

contract DSStakeVoteTest is Test {
    DSStakeVoteModel m;
    function setUp() {
        m = new DSStakeVoteModel();
    }
    function testVotesSynced() {
        m.setVote(10**24);
        m.transfer(address(0x0), 10);
        assertEq( m.balanceOf(this), 10**24 - 10 );
    }
}
