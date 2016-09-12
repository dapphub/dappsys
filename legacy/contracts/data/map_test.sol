import 'dapple/test.sol';
import 'data/map.sol';

contract MapTest is Test, DSMapEvents {
    DSMap map;

    function MapTest() {
        map = new DSMap();
    }

    function testSetAndGet() {
        expectEventsExact(map);
        Set("The Answer", 42);

        map.set("The Answer", 42);
        assertEq(uint(map.get("The Answer")), 42);
    }

    function testGetUnset() {
        assertEq(uint(map.get("Foobar")), 0);
    }
}
