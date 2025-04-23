import 'package:flutter/material.dart';
import 'cbc_dec.dart';
import 'rsa_dec.dart';

class DecryptionMainPage extends StatefulWidget {
  const DecryptionMainPage({super.key});

  @override
  State<DecryptionMainPage> createState() => _DecryptionMainPageState();
}

class _DecryptionMainPageState extends State<DecryptionMainPage> {
  final TextEditingController encryptedController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  String encryptionMode = 'CBC';
  String outputFormat = 'Hex';

  late int rsaD;
  late int rsaN;
  late String cbcKey;
  late String cbcIv;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    if (args != null) {
      encryptedController.text = args['encryptedText'] ?? '';
      encryptionMode = args['encryptionMode'] ?? 'CBC';
      outputFormat = args['outputFormat'] ?? 'Hex';

      if (args.containsKey('rsa_d')) {
        rsaD = args['rsa_d'];
        rsaN = args['rsa_n'];
      }

      if (args.containsKey('cbc_key')) {
        cbcKey = args['cbc_key'];
        cbcIv = args['cbc_iv'];
      }

      if (encryptedController.text.isNotEmpty) {
        handleDecryption();
      }
    }
  }

  void handleDecryption() {
    String input = encryptedController.text.trim();
    if (input.isEmpty) {
      setState(() => resultController.text = "Please enter encrypted text");
      return;
    }

    setState(() {
      if (encryptionMode == 'CBC') {
        final decrypter = CBCDecryption(cbcKey: cbcKey, cbcIv: cbcIv);
        resultController.text = decrypter.decrypt(input);
      } else if (encryptionMode == 'RSA') {
        final decrypter = RSADecryption(rsaD: rsaD, rsaN: rsaN, outputFormat: outputFormat);
        resultController.text = decrypter.decrypt(input);
      } else {
        resultController.text = "Invalid encryption mode";
      }
    });
  }

  Widget buildRadio(String label) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: encryptionMode == label ? Colors.white : Colors.black,
        ),
      ),
      selected: encryptionMode == label,
      onSelected: (_) => setState(() => encryptionMode = label),
      selectedColor: Colors.black,
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Decryption Page',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Encrypted Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: encryptedController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Paste encrypted text here...',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Decryption Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['CBC', 'RSA'].map(buildRadio).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: handleDecryption,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black),
                elevation: 2,
              ),
              child: const Text(
                'Decrypt',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Decrypted Result',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: resultController,
                      readOnly: true,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black),
                elevation: 2,
              ),
              child: const Text(
                'Back to Encryption',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
