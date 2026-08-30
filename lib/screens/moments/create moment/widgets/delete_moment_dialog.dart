import 'package:flutter/material.dart';

class DeleteMomentDialog extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;

  const DeleteMomentDialog({
    super.key,
    this.onCancel,
    this.onDelete,
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xffFF4D6D)
                    .withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xffFF4D6D),
                size: 25,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Delete moment?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'This moment will be permanently '
                  'removed. This action cannot be undone.',
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
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                  const Color(0xffFF4D6D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Delete moment',
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
                onPressed: onCancel ??
                        () {
                      Navigator.of(context).pop();
                    },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}