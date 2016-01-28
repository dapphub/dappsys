// A contract that is simply a fresh storage address space.
// If you are storing addresses, consider using DSNullableMap.

import 'auth/auth.sol';

contract DSMap is DSAuth {
	mapping( bytes32 => bytes32 ) _storage;

    event Set( bytes32 indexed key, bytes32 indexed value );

	function get( bytes32 key ) returns (bytes32 value) 
    {
		 return _storage[key];
	}
	function set( bytes32 key, bytes32 value )
             auth()
    {
		_storage[key] = value;
	}
}
