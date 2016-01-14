import 'actor/base.sol';
import 'dapple/debug.sol';
// A multisig actor optimized for ease of use.
// The user never has to pack their own calldata (using easyPropose),
// eliminating the need for UI support or helper contracts.
// 
contract DSEasyMultisig is DSBaseActor, Debug
{
    uint _required;
    uint _member_count;
    uint _expiration;
    uint _last_action_id;
    // temporary setup storage
    address _tmp_authority;
    uint _members_added;
    struct action {
        address target;
        bytes calldata;
        uint value;
        uint gas;

        uint confirmations; // If this number reaches `required`, you can trigger
        uint expiration;
        bool triggered;
        bool result;
    }
    mapping( uint => action ) public actions;
    mapping( uint => mapping( address => bool ) ) confirmations;
    mapping( address => bytes ) easy_calldata;
    mapping( address => bool ) is_member;

    event Proposed( uint action_id );
    event Confirmed( uint action_id, address who );
    event Triggered( uint action_id, bool result );

    function DSEasyMultisig( uint required, uint member_count, uint expiration ) {
        _tmp_authority = msg.sender;
        _required = required;
        _member_count = member_count;
        _expiration = expiration;
    }
    function getInfo() constant returns (uint required, uint members, uint expiration, uint last_proposed_action)
    {
        return (_required, _member_count, _expiration, _last_action_id);
    }
    function getActionStatus(uint action_id) 
             constant
             returns (uint confirmations, uint expiration, bool triggered, bool result)
    {
        var a = actions[action_id];
        return (a.confirmations, a.expiration, a.triggered, a.result);
    }
    function addMember( address who ) returns (bool)
    {
        if( msg.sender != _tmp_authority ) {
            return false;
        }
        if( is_member[who] ) {
            return false;
        }
        is_member[who] = true;
        _members_added++;
        if( _members_added == _member_count ) {
            delete _tmp_authority;
            delete _members_added;
        }
        return true;
    }
    function isMember( address who ) constant returns (bool) {
        return is_member[who];
    }
    function easyPropose( address target, uint value, uint gas ) returns (uint action_id) {
        return propose( target, easy_calldata[msg.sender], value, gas );
    }
    function() {
        easy_calldata[msg.sender] = msg.data;
    }
    // Propose an action.
    // Return value 0 means error.
    // Anyone can propose - only members can confirm so others are just wasting gas
    // if they try to do anything silly.
    // This does mean you need to be careful about checking that your transactions confirmed.
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
    function confirm( uint action_id ) returns (bool triggered) {
        //log_named_uint("entering confirm for id", action_id);
        if( is_member[msg.sender] && !confirmations[action_id][msg.sender] ) {
            //logs("no existing confirmations for member");
            confirmations[action_id][msg.sender] = true;
            var a = actions[action_id];
            var confs = a.confirmations;
            //log_named_uint("current confirmations", confs);
            a.confirmations = a.confirmations + 1;
            //log_named_uint("confirmations after increment", a.confirmations);
            actions[action_id] = a;
            //log_named_uint("confirmations after ++/store", actions[action_id].confirmations);
            Confirmed(action_id, msg.sender);
            return trigger(action_id);
        }
        return false;
    }
    function trigger( uint action_id ) returns (bool triggered) {
        //logs("entering trigger");
        var a = actions[action_id];
        if( a.confirmations < _required ) {
            //logs("too few confirmations, skipping");
            return false;
        }
        if( block.timestamp > a.expiration ) {
            //logs("too far in the future, skipping");
            return false;
        }
        a.result = exec( a.target, a.calldata, a.value, a.gas );
        //logs("triggered action");
        if( a.result ) {
            //logs("result success");
        } else {
            //logs("result success");
        }
        a.triggered = true;
        actions[action_id] = a;
        Triggered(action_id, a.result);
        return true;
    }
}
