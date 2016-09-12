import 'dapple/test.sol';
import 'data/nullmap.sol';

contract NullMapTest is Test, DSNullMapEvents {
    DSNullMap map;

    function NullMapTest() {
        map = new DSNullMap();
    }

    function testSetAndGet() {
        expectEventsExact(map);
        SetNullable("The Answer", 42, true);

        map.set("The Answer", 42);
        assertEq(uint(map.get("The Answer")), 42);
    }

    function testFailGetUnset() {
        map.get("Foobar");
    }

    function testTryGetUnset() {
        var (value, wasSet) = map.tryGet("Foobar");
        assertFalse(wasSet);
        assertEq(uint(value), 0);
    }

    function testTryGet() {
        expectEventsExact(map);
        SetNullable("The Answer", 42, true);

        map.set("The Answer", 42);
        var (value, wasSet) = map.tryGet("The Answer");
        assertTrue(wasSet);
        assertEq(uint(value), 42);
    }

    function testUnset() {
        expectEventsExact(map);
        SetNullable("The Answer", 42, true);
        SetNullable("The Answer", 0, false);

        map.set("The Answer", 42);
        map.unset("The Answer");
        var (value, wasSet) = map.tryGet("The Answer");
        assertFalse(wasSet);
        assertEq(uint(value), 0);
    }
}
