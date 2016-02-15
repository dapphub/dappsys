import 'auth/authority.sol';
import 'auth/authorized.sol';
import 'auth/util.sol';
import 'auth/events.sol';
import 'auth/enum.sol';

contract DSAuth is DSAuthorized {} //, is DSAuthorizedEvents, DSAuthModesEnum
contract DSAuthUser is DSAuthUtils {} //, is DSAuthModesEnum {}
