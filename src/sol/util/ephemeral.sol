// Contracts that can and should be deleted ASAP. Useful for a deploy sequence
// where you don't need to use intermediate addresses in another contract right away.
// TODO make keeper plugin?
contract DSEphemeral {
    function cleanUp() {
        suicide(msg.sender);
    }
}
