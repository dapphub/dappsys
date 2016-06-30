// calm down peter
contract SensitiveContract {
    // Will I get tricked?
    address who_touched_me;
    function touch() {
        who_touched_me = msg.sender;
    }
}

contract Attacker {
    SensitiveContract _sc;
    function Attacker(SensitiveContract sc) {
        _sc = sc;
    }
    function harmlessLookingFunction() {
        var sig = bytes4(sha3("touch()"));
        assembly {
            delegatecall(_sc, sig);
        }
    }
}

contract DelegateCallTest is Test {
    SensitiveContract sc;
    Attacker attacker;
    function setUp() {
        sc = new SensitiveContract();
        attacker = Attacker(sc);
    }
    function testAttack() {
        attacker.harmlessLookingFunction();
    }
}
