contract GroupAuthority is DSAuthority {
	mapping( address => bytes32 ) _perms_has;
	mapping( address => mapping( bytes4 => bytes32 ) ) _perms_req;

	function can_call( address caller, address callee, bytes4 sig ) returns (bool) {
		var has = _perms_has[caller];
		var req = _perms_req[callee][sig];
		return ((has & req) != bytes32(0));
	}
}
