class CBC {
  final String iv = "MyFixedIVInit1234";
  final String cbcKey = "MyFixedCBCKey_12";

  String encrypt(String message) {
    const int blockSize = 16;
    String key = cbcKey;
    String localIV = iv;

    while (message.length % blockSize != 0) {
      message += '\x00';
    }

    List<String> blocks = [];
    for (int i = 0; i < message.length; i += blockSize) {
      blocks.add(message.substring(i, i + blockSize));
    }

    List<String> encryptedBlocks = [];
    String previousBlock = localIV;

    for (var block in blocks) {
      List<int> xorWithIV = List.generate(blockSize, (i) => block.codeUnitAt(i) ^ previousBlock.codeUnitAt(i));
      List<int> encrypted = List.generate(blockSize, (i) => xorWithIV[i] ^ key.codeUnitAt(i));
      String encryptedStr = encrypted.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
      encryptedBlocks.add(encryptedStr);
      previousBlock = String.fromCharCodes(encrypted);
    }

    return encryptedBlocks.join(" ");
  }
}
