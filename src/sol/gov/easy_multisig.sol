import 'actor/base.sol';
import 'dapple/debug.sol';

/* A multisig actor optimized for ease of use.
 * The user never has to pack their own calldata. Instead, use `easyPropose`.
 * This eliminates the need for UI support or helper contracts.
 * 
 * The `easyPropose` workflow is:
 * 1) `TargetType(address(multisig)).doAction(arg1, arg2);`
 * 2) `multisig.easyPropose(address(target), value, gas);`
 * 
 * This is equivalent to `propose(address(my_target), <calldata>, value, gas);`,
 * where calldata is correctly formatted for `TargetType(target).doAction(arg1, arg2)`
 */
contract DSEasyMultisig is DSBaseActor
                         , DSAuth
{
    // How many confirmations an action needs to execute.
    uint _required;
    // How many members this multisig has.
    uint _member_count;
    // Auto-locks once this reaches zero.
    uint _members_remaining;
    // Maximum time between proposal time and trigger time.
    uint _expiration;
    uint _last_action_id;


    struct action {
        address target;
        bytes calldata;
        uint value;
        uint gas; // 0 means "all"!

        uint confirmations; // If this number reaches `required`, you can trigger
        uint expiration; // Last timestamp this action can execute
        bool triggered; // Have we tried to trigger this action
        bool result; // What is the result of the action which we tried to trigger
    }
    mapping( uint => action ) public actions;
    // action_id -> member -> confirmed
    mapping( uint => mapping( address => bool ) ) confirmations;
    // A record of the last fallback calldata recorded for this sender.
    // This is an easy way to create proposals for most actions.
    mapping( address => bytes ) easy_calldata;
    // Can this address add confirmations?
    mapping( address => bool ) is_member;
   
    event MemberAdded( address who ); 
    event Proposed( uint action_id );
    event Confirmed( uint action_id, address who );
    event Triggered( uint action_id, bool result );

    function DSEasyMultisig( uint required, uint member_count, uint expiration ) {
        _required = required;
        _member_count = member_count;
        _members_remaining = member_count;
        _expiration = expiration;
    }
    // The setup authority can add members until they reach `member_count`, after which the
    // contract is finalized (`_authority` is set to 0).
    function addMember( address who ) auth() returns (bool)
    {
        if( is_member[who] ) {
            return false;
        }
        is_member[who] = true;
        MemberAdded(who);
        _members_remaining--;
        if( _members_remaining == 0 ) {
            _authority = address(0x0);
            _auth_mode = false;
        }
        return true;
    }
    function isMember( address who ) constant returns (bool) {
        return is_member[who];
    }

    // Some constant getters
    function getInfo()
             constant
             returns ( uint required, uint members, uint expiration, uint last_proposed_action)
    {
        return (_required, _member_count, _expiration, _last_action_id);
    }
    // Public getter for the action mapping doesn't work in web3.js yet
    function getActionStatus(uint action_id) 
             constant
             returns (uint confirmations, uint expiration, bool triggered, bool result)
    {
        var a = actions[action_id];
        return (a.confirmations, a.expiration, a.triggered, a.result);
    }
    // `propose` an action using the calldata from this sender's last call.
    function easyPropose( address target, uint value, uint gas ) returns (uint action_id) {
        return propose( target, easy_calldata[msg.sender], value, gas );
    }
    function() {
        easy_calldata[msg.sender] = msg.data;
    }

    // Propose an action.
    // Anyone can propose an action.
    // Attempts to also confirm (and then trigger) the action.
    // Only members can confirm actions.
    // Warning! Don't forget 0 gas means "all the gas"!
    function propose( address target, bytes calldata, uint value, uint gas )
             returns (uint action_id)
    {
        action memory a;
        a.target = target;
        a.calldata = calldata;
        a.value = value;
        a.gas = gas;
        a.expiration = block.timestamp + _expiration;
        // Increment first because, 0 is not a valid ID.
        _last_action_id++;
        actions[_last_action_id] = a;
        Proposed(_last_action_id);
        confirm(_last_action_id);
        return _last_action_id;
    }
    // Attempts to confirm the action.
    // Only members can confirm actions.
    // Attempts to trigger the action 
    function confirm( uint action_id ) returns (bool triggered) {
        if( is_member[msg.sender] && !confirmations[action_id][msg.sender] ) {
            confirmations[action_id][msg.sender] = true;
            var a = actions[action_id];
            var confs = a.confirmations;
            a.confirmations = a.confirmations + 1;
            actions[action_id] = a;
            Confirmed(action_id, msg.sender);
            return trigger(action_id);
        }
        return false;
    }
    // Attempts to trigger the action.
    // Fails if there are not enough confirmations or if the action has expired.
    function trigger( uint action_id ) returns (bool triggered) {
        var a = actions[action_id];
        if( a.confirmations < _required ) {
            return false;
        }
        if( block.timestamp > a.expiration ) {
            return false;
        }
        a.result = exec( a.target, a.calldata, a.value, a.gas );
        a.triggered = true;
        actions[action_id] = a;
        Triggered(action_id, a.result);
        return true;
    }
}
