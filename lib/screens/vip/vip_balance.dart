import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VipBalance extends StatelessWidget {
  final int coins;
  final int diamonds;

  const VipBalance({
    super.key,
    this.coins = 25000,
    this.diamonds = 850,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff6C3BFF),
              Color(0xffB43EFF),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(.30),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [

            Text(
              "Your Balance",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Expanded(
                  child: _balanceCard(
                    icon: Icons.monetization_on,
                    iconColor: Colors.amber,
                    title: "Coins",
                    value: coins.toString(),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _balanceCard(
                    icon: Icons.diamond,
                    iconColor: Colors.cyanAccent,
                    title: "Diamonds",
                    value: diamonds.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Divider(
              color: Colors.white.withOpacity(.20),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                ),

                const SizedBox(width: 8),

                Text(
                  "Upgrade today and unlock all VIP privileges",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: iconColor,
            size: 34,
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}