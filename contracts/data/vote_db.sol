// reactive vote DB

import 'auth.sol';

contract DSVoteDB is DSAuth {
    uint issue_id;
    uint proposal_id;
    struct IPFSHash {
        bytes20 first;
        bytes20 second;
    }
    struct Proposal {
        uint issue_id;
        uint proposal_id;
        bytes8 topic;
        address owner;
        uint vote;
        uint16 expiration;
    }
    mapping( bytes8 => IPFSHash ) topics;
    mapping( address => mapping( bytes8 => Ballot ) ) ballots;
}

// anyone can post a bond to propose a proposal.
contract DSReactiveStakeVote is DSAuth {
    function () returns (bool) {
    }
    function() {
        target.call.value(msg.value)(msg.data);
    }
}
