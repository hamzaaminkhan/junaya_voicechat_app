import 'package:flutter/material.dart';

class DiscardMomentDialog extends StatelessWidget {
  final VoidCallback? onKeepEditing;
  final VoidCallback? onDiscard;
  final VoidCallback? onSaveDraft;

  const DiscardMomentDialog({
    super.key,
    this.onKeepEditing,
    this.onDiscard,
    this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          22,
          20,
          16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff151522),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(.06),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xffFF4D6D)
                    .withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xffFF4D6D),
                size: 24,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Leave this moment?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'You have unsaved changes. '
                  'Would you like to save them as a draft?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff898998),
                fontSize: 13,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSaveDraft,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                  const Color(0xffA855F7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save as draft',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: onKeepEditing,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Keep editing',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 2),

            TextButton(
              onPressed: onDiscard,
              child: const Text(
                'Discard',
                style: TextStyle(
                  color: Color(0xffFF4D6D),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}