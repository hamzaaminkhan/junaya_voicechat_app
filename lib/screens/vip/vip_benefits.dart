import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VipBenefits extends StatelessWidget {
  const VipBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> benefits = [
      {
        "icon": Icons.workspace_premium,
        "title": "Premium Badge",
        "subtitle": "Show your VIP status everywhere",
      },
      {
        "icon": Icons.account_circle,
        "title": "Exclusive Profile Frame",
        "subtitle": "Beautiful animated profile borders",
      },
      {
        "icon": Icons.login,
        "title": "Entrance Effect",
        "subtitle": "Special animation when joining rooms",
      },
      {
        "icon": Icons.card_giftcard,
        "title": "Exclusive Gifts",
        "subtitle": "Access premium gifts only for VIPs",
      },
      {
        "icon": Icons.diamond,
        "title": "Monthly Diamonds",
        "subtitle": "Receive free diamonds every month",
      },
      {
        "icon": Icons.mic,
        "title": "Priority Room Access",
        "subtitle": "Join popular rooms faster",
      },
      {
        "icon": Icons.headset_mic,
        "title": "VIP Support",
        "subtitle": "Get priority customer support",
      },
      {
        "icon": Icons.discount,
        "title": "Gift Discounts",
        "subtitle": "Enjoy discounts on selected gifts",
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "VIP Benefits",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
        
            const SizedBox(height: 18),
        
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: benefits.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount:2,

                childAspectRatio:0.75,

                crossAxisSpacing:15,

                mainAxisSpacing:15,

              ),
              itemBuilder: (context, index) {
                final item = benefits[index];
        
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1F38),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.amber.withOpacity(.15),
                        child: Icon(
                          item["icon"],
                          color: Colors.amber,
                          size: 26,
                        ),
                      ),
        
                      const SizedBox(height: 15),
        
                      Text(
                        item["title"],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
        
                      const SizedBox(height: 8),

                      Flexible(

                        child: Text(

                          item["subtitle"],

                          textAlign: TextAlign.center,


                          maxLines:3,

                          overflow:
                          TextOverflow.ellipsis,


                          style: GoogleFonts.poppins(

                            color: Colors.white60,

                            fontSize:12,

                            height:1.3,

                          ),

                        ),

                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}