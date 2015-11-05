// A contract that is simply a fresh storage address space.
// TODO use storage space directly as soon as possible.
contract DSMap is DSAuth {
	mapping( bytes32 => bytes32 ) _storage;
	function get( bytes32 key ) returns (bytes32 value, bool ok) {
		 return (_storage[key], true);
	}
	function set( bytes32 key, bytes32 value )
		 auth()
	    	 returns (bool ok) 
	{
		_storage[key] = value;
		return true;
	}
}
