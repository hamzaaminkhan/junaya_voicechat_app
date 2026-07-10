import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/screens/vip/vip_balance.dart';
import 'package:junaya_voicechat_app/screens/vip/vip_benefits.dart';
import 'package:junaya_voicechat_app/screens/vip/vip_button.dart';
import 'package:junaya_voicechat_app/screens/vip/vip_header.dart';
import 'package:junaya_voicechat_app/screens/vip/vip_plans.dart';

import '../../theme/app_colors.dart';


class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "VIP Membership",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: const [

              SizedBox(height: 10),

              /// Premium Header
              VipHeader(),

              SizedBox(height: 30),

              /// VIP Benefits
              VipBenefits(),

              SizedBox(height: 35),

              /// Membership Plans
              VipPlans(),

              SizedBox(height: 35),

              /// Coin & Diamond Balance
              VipBalance(),

              SizedBox(height: 35),

              /// Purchase Button
              VipButton(),

            ],
          ),
        ),
      ),
    );
  }
}