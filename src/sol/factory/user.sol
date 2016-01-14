import 'factory/factory.sol';

contract DSFactoryUser {
    DSFactory _factory;
    function FactoryUser( DSFactory f ) {
        _factory = f;
    }
}
