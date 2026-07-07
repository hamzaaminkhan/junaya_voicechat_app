import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff08080F),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 70),

            // Logo
            Center(
              child: Image.asset(
                "assets/logo.jpg",
                width: 120,
                height: 120,
              ),
            ),

            const SizedBox(height: 90),

            // Tagline
            const Text(
              "Invest and earn rewards",
              style: TextStyle(
                color: Color(0xffF4C542),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            // Bottom Card
            Container(
              width: double.infinity,
              height: 270,
              decoration: const BoxDecoration(
                color: Color(0xff8E35D8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 25,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: List.generate(
                        3,
                            (index) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xffFFD54F),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Welcome !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Experience a wonderful\nmoment with Junaya",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF52A73),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 8,
                        ),

                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.login,
                          );
                        },

                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}