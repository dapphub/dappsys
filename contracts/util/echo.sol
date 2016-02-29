contract DSEcho {
  function () returns (bytes) {
    return msg.data;
  }
}
