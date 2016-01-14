import 'factory/factory.sol';

contract FactoryUser {
    DSFactory _factory;
    DSFactory1Helper1 _h1;
    function FactoryUser( DSFactory f ) {
        _factory = f;
    }
}
