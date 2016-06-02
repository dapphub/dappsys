import 'dapple/test.sol';

import 'data/nullmap.sol';
import 'component.sol';

contract SampleComponent is DSComponent {
    bytes32 public var1;
    address public var2;
    function SampleComponent( DSNullMap env ) DSComponent(env) {}
    function refreshEnvironment() {
        var1 = _env.get("var1");
        var2 = address(_env.get("var2"));
    }
}

contract DSComponentTest is Test {
    DSNullMap env;
    SampleComponent component;
    function setUp() {
        env = new DSNullMap();
        env.set("var1", "hello");
        env.set("var2", bytes32(address(this)));
        component = new SampleComponent(env);
    }
    function testLocalVarsSetOnConstruction() {
        assertEq32(component.var1(), "hello");
        assertEq(component.var2(), this);
    }
    function testLocalVarsSetOnUpdate() {
        var env2 = new DSNullMap();
        env2.set("var1", "world");
        env2.set("var2", 0);
        component.updateEnvironment(env2);
        assertEq32(component.var1(), "world");
        assertEq(address(component.var2()), 0);
    }
    function testFailNonOwnerCantUpdate() {
        var T = new Tester();
        T._target(component);
        var env2 = new DSNullMap();
        DSComponent(T).updateEnvironment(env2);
    }
}
