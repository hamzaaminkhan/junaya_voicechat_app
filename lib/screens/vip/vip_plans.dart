import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VipPlans extends StatefulWidget {
  const VipPlans({super.key});

  @override
  State<VipPlans> createState() => _VipPlansState();
}

class _VipPlansState extends State<VipPlans> {
  int selectedPlan = 1;

  final List<Map<String, String>> plans = [
    {
      "title": "Weekly",
      "price": "499 Coins",
      "duration": "7 Days",
      "badge": "",
    },
    {
      "title": "Monthly",
      "price": "1499 Coins",
      "duration": "30 Days",
      "badge": "MOST POPULAR",
    },
    {
      "title": "Yearly",
      "price": "12999 Coins",
      "duration": "365 Days",
      "badge": "BEST VALUE",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Your Plan",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final bool isSelected = selectedPlan == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPlan = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xff6C3BFF), Color(0xffB43EFF)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xff1A1F38),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.amber : Colors.white12,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: .35),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.amber,
                        child: Icon(
                          Icons.workspace_premium,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan["title"]!,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              plan["duration"]!,
                              style: GoogleFonts.poppins(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            plan["price"]!,
                            style: GoogleFonts.poppins(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 6),

                          if (plan["badge"]!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                plan["badge"]!,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
