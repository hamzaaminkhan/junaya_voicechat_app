import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/widgets/space_background.dart';

class VipPurchaseScreen extends StatelessWidget {
  const VipPurchaseScreen({super.key});

  static const List<_VipPlan> _plans = [
    _VipPlan(level: 1, title: 'VIP 1', price: '4.99', benefits: ['Basic profile frame', 'VIP badge', 'Exclusive entrance effect']),
    _VipPlan(level: 2, title: 'VIP 2', price: '9.99', benefits: ['Premium profile frame', 'Animated badge', 'Extra room effects']),
    _VipPlan(level: 3, title: 'VIP 3', price: '19.99', benefits: ['Deluxe frame', 'Priority support', 'Exclusive gifts']),
    _VipPlan(level: 4, title: 'VIP 4', price: '29.99', benefits: ['Royal frame', 'Premium entrance', 'Special room identity']),
    _VipPlan(level: 5, title: 'VIP 5', price: '49.99', benefits: ['Legend frame', 'Top-tier badge', 'All VIP perks']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SpaceBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'VIP Purchase',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.purpleAccent.withValues(alpha: .5)),
                        gradient: const LinearGradient(
                          colors: [Color(0xCC14051F), Color(0xCC22083B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.workspace_premium, color: Colors.amber, size: 26),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Unlock Junaya VIP Benefits',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Purchase VIP to get exclusive frames, badges, entrance effects and premium room identity.',
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._plans.map((plan) => _VipPlanCard(plan: plan)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VipPlanCard extends StatelessWidget {
  final _VipPlan plan;

  const _VipPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12071F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: .45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withValues(alpha: .14),
                ),
                child: const Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Perfect for hosts and premium users',
                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                plan.price,
                style: GoogleFonts.poppins(
                  color: Colors.amber,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...plan.benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('${plan.title} purchase flow will be connected next.')),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Buy ${plan.title}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VipPlan {
  final int level;
  final String title;
  final String price;
  final List<String> benefits;

  const _VipPlan({
    required this.level,
    required this.title,
    required this.price,
    required this.benefits,
  });
}
