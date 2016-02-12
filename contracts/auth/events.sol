import 'auth/enum.sol';

contract DSAuthorizedEvents is DSAuthModesEnum {
    event DSAuthUpdate( address auth, DSAuthModes mode );
}

