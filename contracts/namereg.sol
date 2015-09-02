//  blocked on solidity improvements  (indexing into `bytes`)
import 'dappsys/control/auth.sol';

contract DSDataStore {
    function get( bytes query ) returns (bytes data);
    function set( bytes key, bytes data );
}

// TODO
// We can't do this until we have a way of indexing into `bytes` arguments
contract DSNameReg is DSDataStore
                    , DSAuth {
    mapping( bytes32 => bytes32 ) _values;
    mapping( bytes32 => address)  _owners;
    mapping( bytes32 => byte)     _types;

    // 0x0   data
    // 0x1   contract
    // 0x2   key
    // 0x3   DSNameReg
    modifier name_auth( bytes32 which ) {
        if( _owners[which] == address(0x0) ) {
            _owners[which] = msg.sender;
            _
        } else {
            if( _owners[which] == msg.sender || authed()) {
                _
            }
        }
    }
    function set_subregistrar( bytes32 name, DSNameReg reg )
             name_auth( name )
    {
        _values[name] = bytes32(address(reg));
        _types[name] = 0x2;
    }
    function set( bytes32 name, bytes32 value )
             name_auth( name )
             returns (bool)
    {
        if( validate_name( name ) ) {
            _values[name] = value;
            return true;
        }
        return false;
    }
    function set( bytes key, bytes value ) {}
    function validate_name( bytes32 name )
             internal returns (bool)
    {
    /*
        for( var i = 0; i < 32; i++ ) {
            if( name[i] == "/" ) {
            }
        }
    */
        return false;
    }
    function get( bytes query ) returns (bytes value) {
        get( query, 0 );
    }
    function get( bytes query, uint index ) returns (bytes value) {
    }
}
