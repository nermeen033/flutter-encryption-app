class RSADecryption {
  final int rsaD;
  final int rsaN;
  final String outputFormat;

  RSADecryption({required this.rsaD, required this.rsaN, required this.outputFormat});

  int _modPow(int base, int exponent, int mod) {
    int result = 1;
    base = base % mod;
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = (result * base) % mod;
      }
      exponent = exponent >> 1;
      base = (base * base) % mod;
    }
    return result;
  }

  String decrypt(String encryptedText) {
    try {
      List<int> numbers = [];

      if (outputFormat == 'Hex') {
        List<String> hexParts = encryptedText.split(' ');
        for (String part in hexParts) {
          numbers.add(int.parse(part, radix: 16));
        }
      } else {
        numbers = encryptedText.split(',').map((e) => int.parse(e)).toList();
      }

      String decrypted = '';
      for (int num in numbers) {
        if (num >= rsaN) {
          return "Encrypted number $num exceeds RSA modulus $rsaN. Cannot decrypt.";
        }
        int dec = _modPow(num, rsaD, rsaN);
        decrypted += String.fromCharCode(dec);
      }

      return decrypted;
    } catch (e) {
      return "RSA Decryption Error: $e\nMake sure you selected the correct output format";
    }
  }
}
