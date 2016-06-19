// testing transfer via `selfdestruct` to avoid executing code on recipient

import 'dapple/test.sol';

contract DeliveryBoy{
    /*
     * Delivery boy is very important, but not so clever
     */
    function deliver(address recipient){
        selfdestruct(recipient);
    }
}

contract MailMan{
    
    /*
     * The MailMan delivers
     * No-fuzz delivery of ether to the recipient. 
     * Mailman tolerates no code-execution or funny stuff on cash delivery
     * Nobody owns the mailman (no 'owner')
     * Mailman remembers nothing (no storage slots)
     *
     * You wanna use mailman for payment?
     * Go ahead, but its'a gonna cost'ya some extra gas, capisce...
     */
     function payRecipient(address recipient)
     {
        DeliveryBoy d = new DeliveryBoy();
        d.deliver.value(msg.value)(recipient);
     }
}

contract StatefulFallbackGuy {
    bool public touched;
    function() {
        touched = true;
    }
}

contract DeliveryBoyTest is Test {
    MailMan mm;
    StatefulFallbackGuy bob;
    function setUp() {
        mm = new MailMan();
        bob = new StatefulFallbackGuy();
        assertEq(bob.balance, 0);
    }
    function testDelivery() {
        mm.payRecipient.value(100)(bob);
        assertEq(bob.balance, 100);
        assertFalse(bob.touched());
    }
}
