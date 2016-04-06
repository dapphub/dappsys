// reactive vote DB

import 'auth.sol';

contract DSVoteDB is DSAuth {
}

// anyone can post a bond to propose a proposal.
contract DSReactiveStakeVote is DSAuth {
    function () returns (bool) {
    }
    function() {
        target.call.value(msg.value)(msg.data);
    }
}
