import 'token/base.sol';
import 'actor/base.sol';

contract DSStakeVoteModel is DSTokenBase(10**24)
                           , DSBaseActor // for `exec`
{
    mapping( address => uint ) public _votes; // This should be something like (ballot,issue)->vote
    Action[] public _proposals;
    struct Action {
        address target;
        uint value;
        bytes calldata;
        bool passed;
        bool executed;
    }
    function propose(address target, uint value, bytes calldata ) {
        if( msg.value < value ) throw;        
        _proposals.push(Action(target, value, calldata, false, false));
    }

    // The hard part. @zandy
    function setVote(uint how_much) {
        if( how_much > _balances[msg.sender] ) throw;
        _votes[msg.sender] = how_much;
    }
    function trigger(uint proposal) {
        if( true ) { // vote condition
            var a = _proposals[proposal];
            exec(a.target, a.calldata, a.value);
        }
    }
    function syncVotes(address who) internal {
        _votes[who] = _balances[who];
    }
    // end hard part

    // Override functions that affect voting.
    function transfer(address to, uint amount) returns (bool) {
        super.transfer(to, amount);
        syncVotes(to);
    }
    function transferFrom(address from, address to, uint amount) returns (bool) {
        super.transferFrom(from, to, amount);
        syncVotes(from);
        syncVotes(to);
    }
}
