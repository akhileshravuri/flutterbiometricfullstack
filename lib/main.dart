import 'package:flutter/material.dart';
import 'package:biometric_auth/biometric_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometric Test App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BiometricTestPage(),
    );
  }
}

class BiometricTestPage extends StatefulWidget {
  const BiometricTestPage({super.key});

  @override
  State<BiometricTestPage> createState() => _BiometricTestPageState();
}

class _BiometricTestPageState extends State<BiometricTestPage> {
  final BiometricService _biometricService = BiometricService();
  String _status = 'Test Biometric Features';
  String _pin = '';
  final TextEditingController _pinController = TextEditingController();

  Future<void> _testBiometricAvailability() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    setState(() {
      _status = 'Biometric available: $isAvailable';
    });
  }

  Future<void> _testBiometricAuth() async {
    final success = await _biometricService.authenticateWithBiometrics();
    setState(() {
      _status = 'Biometric auth result: $success';
    });
  }

  Future<void> _testFaceAuth() async {
    final success = await _biometricService.authenticateWithFace();
    setState(() {
      _status = 'Face auth result: $success';
    });
  }

  // PIN verification is completely handled by the BiometricService package
  Future<void> _setPin() async {
    final success = await _biometricService.setPin(_pinController.text);
    setState(() {
      _status = 'PIN set result: $success';
    });
    if (success) {
      _pinController.clear();
    }
  }

  Future<void> _verifyPin() async {
    final success = await _biometricService.verifyPin(_pinController.text);
    setState(() {
      _status = 'PIN verification result: $success';
    });
    _pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Test App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testBiometricAvailability,
              child: const Text('Test Biometric Availability'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testBiometricAuth,
              child: const Text('Test Biometric Authentication'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testFaceAuth,
              child: const Text('Test Face Authentication'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'Enter PIN',
                hintText: 'Enter at least 4 characters',
              ),
              obscureText: true, // Hide PIN input for security
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _setPin, child: const Text('Set PIN')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _verifyPin,
              child: const Text('Verify PIN'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
