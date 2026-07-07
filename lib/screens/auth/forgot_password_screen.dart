import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              // Back Button
              IconButton(
                onPressed: () {
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Enter your email and we'll send you the\ninstructions on how to reset your password.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 45),

              const Text(
                "Enter your email address",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),

                cursorColor: Colors.amber,

                decoration: const InputDecoration(

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 2,
                    ),
                  ),

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF21B72),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    elevation: 6,
                  ),

                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.phoneVerification,
                    );
                  },

                  child: const Text(
                    "Recover Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}