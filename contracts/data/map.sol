// A contract that is simply a fresh storage address space.
// If you are storing addresses, consider using DSNullableMap.

import 'auth.sol';

contract DSMapEvents {
    event Set( bytes32 indexed key, bytes32 indexed value );
}

contract DSMap is DSAuth, DSMapEvents {
    mapping( bytes32 => bytes32 ) _storage;

    function get( bytes32 key ) constant returns (bytes32 value) {
        return _storage[key];
    }

    function set( bytes32 key, bytes32 value ) auth() {
        Set(key, value);
        _storage[key] = value;
    }
}
