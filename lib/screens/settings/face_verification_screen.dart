import 'package:flutter/material.dart';

class FaceVerificationScreen extends StatelessWidget {
  const FaceVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Verification')),
      body: const Center(child: Text('Face Verification')),
    );
  }
}
