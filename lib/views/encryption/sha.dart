// sha.dart
class SHA1 {
  static String hash(String input) {
    input = input.replaceAll(RegExp(r'\r?\n'), '');
    List<int> asciiCodes = input.codeUnits;
    String binary = asciiCodes.map((e) => e.toRadixString(2).padLeft(8, '0')).join();
    int originalLength = asciiCodes.length * 8;

    binary += '1';
    while (binary.length % 512 != 448) {
      binary += '0';
    }

    String length64Bit = originalLength.toRadixString(2).padLeft(64, '0');
    binary += length64Bit;

    int h0 = 0x67452301;
    int h1 = 0xEFCDAB89;
    int h2 = 0x98BADCFE;
    int h3 = 0x10325476;
    int h4 = 0xC3D2E1F0;

    int numChunks = binary.length ~/ 512;
    for (int i = 0; i < numChunks; i++) {
      String chunk = binary.substring(i * 512, (i + 1) * 512);

      List<int> w = List<int>.filled(80, 0);
      for (int j = 0; j < 16; j++) {
        w[j] = int.parse(chunk.substring(j * 32, (j + 1) * 32), radix: 2);
      }

      for (int j = 16; j < 80; j++) {
        w[j] = _leftShift(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
      }

      int a = h0, b = h1, c = h2, d = h3, e = h4;

      for (int j = 0; j < 80; j++) {
        int f, k;
        if (j < 20) {
          f = (b & c) | ((~b) & d);
          k = 0x5A827999;
        } else if (j < 40) {
          f = b ^ c ^ d;
          k = 0x6ED9EBA1;
        } else if (j < 60) {
          f = (b & c) | (b & d) | (c & d);
          k = 0x8F1BBCDC;
        } else {
          f = b ^ c ^ d;
          k = 0xCA62C1D6;
        }

        int temp = (_leftShift(a, 5) + f + e + k + w[j]) & 0xffffffff;
        e = d;
        d = c;
        c = _leftShift(b, 30);
        b = a;
        a = temp;
      }

      h0 = (h0 + a) & 0xffffffff;
      h1 = (h1 + b) & 0xffffffff;
      h2 = (h2 + c) & 0xffffffff;
      h3 = (h3 + d) & 0xffffffff;
      h4 = (h4 + e) & 0xffffffff;
    }

    return _toHex(h0) + _toHex(h1) + _toHex(h2) + _toHex(h3) + _toHex(h4);
  }

  static int _leftShift(int val, int bits) {
    return ((val << bits) | (val >> (32 - bits))) & 0xffffffff;
  }

  static String _toHex(int val) {
    return val.toRadixString(16).padLeft(8, '0');
  }
}