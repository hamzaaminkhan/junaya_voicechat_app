import 'package:flutter/material.dart';

class ClearCacheScreen extends StatelessWidget {
  const ClearCacheScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clear Cache')),
      body: const Center(child: Text('Clear Cache')),
    );
  }
}
