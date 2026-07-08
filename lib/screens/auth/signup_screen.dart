import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: const [
                  Expanded(
                    child: CustomTextField(
                      hint: "First name",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hint: "Last name",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const CustomTextField(
                hint: "Email/phone number",
              ),

              const SizedBox(height: 16),

              const CustomTextField(
                hint: "Password",
                isPassword: true,
              ),

              const SizedBox(height: 16),

              const CustomTextField(
                hint: "Confirm Password",
                isPassword: true,
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Birth of date",
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: dateBox("Date/month"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: dateBox("Year"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gender",
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  genderButton("Male"),
                  genderButton("Female"),
                  genderButton("Others"),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "I Agree with ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "privacy and policy",
                    style: TextStyle(
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF31C79),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.home,
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
        ),
      ),
    );
  }

  static Widget genderButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.amber,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget dateBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.amber,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}