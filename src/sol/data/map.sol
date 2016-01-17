import 'auth/auth.sol';

// A contract that is simply a fresh storage address space.
// TODO use storage space directly as soon as possible (direct-map)
contract DSMap is DSAuth {
	mapping( bytes32 => bytes32 ) _storage;
	function get( bytes32 key ) returns (bytes32 value) {
		 return _storage[key];
	}
	function set( bytes32 key, bytes32 value )
             auth()
	    	 returns (bool ok)
	{
		_storage[key] = value;
		return true;
	}
}
