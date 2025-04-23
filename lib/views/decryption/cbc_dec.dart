class CBCDecryption {
  final String cbcKey;
  final String cbcIv;

  CBCDecryption({required this.cbcKey, required this.cbcIv});

  String decrypt(String encryptedText) {
    try {
      const int blockSize = 16;
      List<String> encryptedBlocks = encryptedText.split(" ");
      String decryptedText = "";
      String previousBlock = cbcIv;

      for (var block in encryptedBlocks) {
        List<int> encryptedBytes = [];
        for (int i = 0; i < block.length; i += 2) {
          encryptedBytes.add(int.parse(block.substring(i, i + 2), radix: 16));
        }

        List<int> afterKeyXor = List.generate(blockSize, (i) => encryptedBytes[i] ^ cbcKey.codeUnitAt(i));
        List<int> decryptedBytes = List.generate(blockSize, (i) => afterKeyXor[i] ^ previousBlock.codeUnitAt(i));

        decryptedText += String.fromCharCodes(decryptedBytes);
        previousBlock = String.fromCharCodes(encryptedBytes);
      }

      decryptedText = decryptedText.replaceAll(RegExp(r'\x00+$'), '');
      return decryptedText;
    } catch (e) {
      return "CBC Decryption Error: $e";
    }
  }
}
