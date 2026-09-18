import 'package:flutter/material.dart';
import 'package:flutter_svga/flutter_svga.dart';

class SvgaTest extends StatelessWidget {
  const SvgaTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('SVGA Test'),
      ),
      body: const Center(
        child: SVGAEasyPlayer(
          assetsName: 'assets/store/frames/gold_frame.svga',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}