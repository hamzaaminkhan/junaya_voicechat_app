import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white, // Bright back arrow
        ),
        title: Text(
          "Wallet",
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff6C3BFF), Color(0xffB43EFF)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),

              child: Column(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 55,
                    color: Colors.amber,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Available Balance",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "\$125.50",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      balanceItem(Icons.monetization_on, "Coins", "25,000"),

                      balanceItem(Icons.diamond, "Diamonds", "12,500"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: actionButton(
                    Icons.add_circle,
                    "Recharge",
                    Colors.green,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: actionButton(
                    Icons.payments,
                    "Withdraw",
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Transactions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            transactionTile(Icons.add, "Recharge", "+ \$20", Colors.green),

            transactionTile(
              Icons.card_giftcard,
              "Gift Sent",
              "- 500 Coins",
              Colors.red,
            ),

            transactionTile(
              Icons.account_balance,
              "Withdrawal",
              "- \$50",
              Colors.orange,
            ),

            transactionTile(
              Icons.card_giftcard,
              "Gift Received",
              "+ 1200 Diamonds",
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget balanceItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget actionButton(IconData icon, String text, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {},
      icon: Icon(icon),
      label: Text(text),
    );
  }

  Widget transactionTile(
    IconData icon,
    String title,
    String amount,
    Color color,
  ) {
    return Card(
      color: const Color(0xff121530),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: const Text("Today", style: TextStyle(color: Colors.white54)),
        trailing: Text(
          amount,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
