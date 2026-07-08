import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({super.key});

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
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Verify your number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Please enter your Country &\nyour phone number.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 45),

              Row(
                children: [

                  // Country Picker
                  Container(
                    width: 70,
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "🇵🇰",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Phone Number
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      cursorColor: Colors.amber,

                      decoration: const InputDecoration(
                        hintText: "+92 3001234567",

                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),

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
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.otp,
                      );
                    },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF21B72),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Next",
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