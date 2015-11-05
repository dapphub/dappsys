// A direct map with authorized reads
contract DSProtectedMap is DSMap {
	function get( bytes32 key ) 
		 auth()
		 returns (bytes32 value, bool ok)
	{
		 return (_storage[key], true);
	}
}
