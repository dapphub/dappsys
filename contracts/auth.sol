import 'auth/authorized.sol';
import 'auth/authority.sol';
import 'auth/enum.sol';

contract DSAuthUser is DSAuth, DSAuthModesEnum {}

// `DSAuthority` is the interface which `DSAuthorized` (`DSAuth`) contracts expect
// their authority to be when they are in the remote auth mode.
contract DSAuthority is DSAuthorityInterface {}

contract DSAuth is DSAuthorized {}


