// Nullable Map. Distinguishes between 0x0 and "unset".
// This is preferable for contracts that store addresses because it
// stops consumers from accidentally calling address(0x0).

import 'auth.sol';

contract DSNullMapEvents {
    event SetNullable( bytes32 indexed key, bytes32 indexed value, bool indexed is_set );
}

contract DSNullMap is DSAuth, DSNullMapEvents {
    struct NullableValue {
        bytes32 _value;
        bool    _set;
    }
    mapping( bytes32 => NullableValue ) _storage;

    function set(bytes32 key, bytes32 value )
             auth()
    {
        _storage[key] = NullableValue(value, true);
        SetNullable( key, value, true );
    }
    function unset(bytes32 key)
             auth()
    {
        _storage[key] = NullableValue(0x0, false);
        SetNullable( key, 0x0, false );
    }

    // Throws.
    function get( bytes32 key )
             constant
             returns (bytes32 value)
    {
        var nvalue = _storage[key];
        if( nvalue._set ) {
            return nvalue._value;
        } else {
            throw;
        }
    }

    function tryGet( bytes32 key ) constant returns (bytes32 value, bool ok ) {
        var nvalue = _storage[key];
        if( nvalue._set ) {
            return (nvalue._value, true);
        } else {
            return (0x0, false);
        }
    }
}
