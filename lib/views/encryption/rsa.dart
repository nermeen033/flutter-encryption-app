class RSA {
  final int rsaE = 65537;
  late int rsaD;
  late int rsaN;

  final int lcgA = 1664525;
  final int lcgC = 1013904223;
  final int lcgM = 4294967296;
  int lcgSeed = DateTime.now().millisecondsSinceEpoch;

  RSA() {
    _generateRSAKeys();
  }

  int _lcgNext() {
    lcgSeed = (lcgA * lcgSeed + lcgC) % lcgM;
    return lcgSeed;
  }

  bool _isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (int i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
  }

  int _generatePrime() {
    int candidate;
    do {
      candidate = _lcgNext() % 1000 + 100;
    } while (!_isPrime(candidate));
    return candidate;
  }

  int _modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) return x;
    }
    return 1;
  }

  void _generateRSAKeys() {
    int p = _generatePrime();
    int q = _generatePrime();

    while (p == q) {
      q = _generatePrime();
    }

    rsaN = p * q;
    int phi = (p - 1) * (q - 1);
    rsaD = _modInverse(rsaE, phi);
  }

  int modPow(int base, int exponent, int mod) {
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

  // Add getters for rsaE, rsaD, and rsaN to access them
  int get rsaEGetter => rsaE;
  int get rsaDGetter => rsaD;
  int get rsaNGetter => rsaN;

  String encrypt(String msg, String outputFormat) {
    try {
      List<int> asciiCodes = msg.codeUnits;
      List<int> encrypted = [];

      for (int i = 0; i < asciiCodes.length; i++) {
        int m = asciiCodes[i];
        if (m >= rsaN) {
          return "Character '${msg[i]}' exceeds RSA modulus. Use smaller characters.";
        }
        int enc = modPow(m, rsaE, rsaN);
        encrypted.add(enc);
      }

      return outputFormat == 'Hex'
          ? encrypted.map((e) => e.toRadixString(16).padLeft(4, '0')).join(' ')
          : encrypted.join(',');
    } catch (e) {
      return "Error during RSA encryption: $e";
    }
  }
}
