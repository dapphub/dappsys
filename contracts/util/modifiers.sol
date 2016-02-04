// Utility modifiers. If you're looking for "owned" or similar, look
// in `auth/authorized.sol`.

contract DSOnlyOnce {
    mapping(bytes4=>bool) __executed_functions;
    modifier only_once() {
        if( !__executed_functions[msg.sig] ) {
            __executed_functions[msg.sig] = true;
            _
        }
    }
}

contract DSOnlyIf {
    modifier only_if( bool what ) {
        if( what ) {
            _
        }
    }
}

contract DSOnlySelf {
    modifier only_self() {
        if( msg.sender == address(this) ) {
            _
        }
    }
}

contract DSOnlyAddress {
    modifier only_address( address who ) {
        if( msg.sender == who ) {
            _
        }
    }
}

contract DSModifiers is DSOnlyOnce
                      , DSOnlyIf
                      , DSOnlySelf
                      , DSOnlyAddress
{
}
