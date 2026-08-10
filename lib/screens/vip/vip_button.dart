import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VipButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const VipButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed:
                  onPressed ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("VIP Purchase Coming Soon")),
                    );
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                elevation: 8,
                shadowColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.workspace_premium, size: 28),
              label: Text(
                "Become VIP",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "Cancel anytime • Secure Payment • Instant Activation",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
