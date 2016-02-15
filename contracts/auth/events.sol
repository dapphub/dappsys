import 'auth/enum.sol';

contract DSAuthorizedEvents is DSAuthModesEnum {
    event DSAuthUpdate( address indexed auth, DSAuthModes indexed mode );
}

