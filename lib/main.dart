import 'package:flutter/material.dart';
import 'package:secure_mindes/views/decryption/decrypted_text.dart'; // صفحة فك التشفير
import 'package:secure_mindes/views/encryption/encrypted_text.dart'; // صفحة التشفير
import 'package:secure_mindes/views/widgets/animated_splash.dart'; // شاشة البداية المتحركة (Splash Screen)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // تحديد اللون الأساسي للتطبيق
      ),
      home: const AnimatedSplash(),  // شاشة البداية المتحركة التي ستظهر عند بدء تشغيل التطبيق
      routes: {
        '/decryption': (context) => const DecryptionMainPage(),  // رابط صفحة فك التشفير
        '/encryption': (context) => const EncryptionMainPage(),  // رابط صفحة التشفير
      },
    );
  }
}
