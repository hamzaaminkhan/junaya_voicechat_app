import 'package:flutter/material.dart';

class DraftsScreen extends StatelessWidget {
  const DraftsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff07070D),
      appBar: AppBar(
        backgroundColor: const Color(0xff07070D),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          'Drafts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      children: [
        SizedBox(
          height: 190,
        ),
        const Icon(
          Icons.edit_note_rounded,
          size: 48,
          color: Colors.white24,
        ),
        const SizedBox(height: 18),
        const Text(
          'No drafts yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Unfinished moments will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}