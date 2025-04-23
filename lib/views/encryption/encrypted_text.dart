import 'package:flutter/material.dart';
import 'rsa.dart';
import 'cbc.dart' as cbc_lib;
import 'sha.dart' as sha_lib;

class EncryptionMainPage extends StatefulWidget {
  const EncryptionMainPage({super.key});

  @override
  State<EncryptionMainPage> createState() => _EncryptionMainPageState();
}

class _EncryptionMainPageState extends State<EncryptionMainPage> {
  final TextEditingController textController = TextEditingController();
  String encryptionMode = 'CBC';
  String result = '';
  String outputFormat = 'Hex';

  late RSA rsa;
  late cbc_lib.CBC cbc;
  late sha_lib.SHA1 sha1;

  @override
  void initState() {
    super.initState();
    rsa = RSA();
    cbc = cbc_lib.CBC();
    sha1 = sha_lib.SHA1();
  }

  void handleEncryption() {
    String input = textController.text;

    setState(() {
      if (encryptionMode == 'CBC') {
        result = cbc.encrypt(input);
      } else if (encryptionMode == 'RSA') {
        result = rsa.encrypt(input, outputFormat);
      } else if (encryptionMode == 'SHA1') {
        result = sha_lib.SHA1.hash(input);
      }
    });
  }

  Widget buildRadio(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: encryptionMode == label,
      onSelected: (_) => setState(() => encryptionMode = label),
      selectedColor: Colors.black,
      labelStyle: TextStyle(
        color: encryptionMode == label ? Colors.white : Colors.black,
      ),
    );
  }

  Widget buildFormatRadio(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: outputFormat == label,
      onSelected: (_) => setState(() => outputFormat = label),
      selectedColor: Colors.black,
      labelStyle: TextStyle(
        color: outputFormat == label ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption Page'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter text',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: textController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your text here...',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Encryption Mode',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['CBC', 'RSA', 'SHA1'].map(buildRadio).toList(),
                    ),

                    if (encryptionMode == 'RSA') ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Output Format',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['Hex', 'Decimal'].map(buildFormatRadio).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: handleEncryption,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Encrypt',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Encryption Result',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: TextEditingController(text: result),
                      readOnly: true,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    
                    if (encryptionMode == 'RSA') ...[
                      const SizedBox(height: 16),
                      const Text(
                        'RSA Key Info',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Public Key (e, n): (${rsa.rsaE}, ${rsa.rsaN})'),
                      Text('Private Key (d, n): (${rsa.rsaD}, ${rsa.rsaN})'),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (result.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please encrypt a message first')),
                  );
                  return;
                }
                Navigator.pushNamed(context, '/decryption', arguments: {
                  'encryptedText': result,
                  'rsa_d': rsa.rsaD,
                  'rsa_n': rsa.rsaN,
                  'cbc_key': cbc.cbcKey,
                  'cbc_iv': cbc.iv,
                  'outputFormat': outputFormat,
                  'encryptionMode': encryptionMode,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Go to Decryption Page',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
