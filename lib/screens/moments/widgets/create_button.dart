import 'package:flutter/material.dart';

class CreateMomentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateMomentButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffA855F7),
                Color(0xff7C3AED),
              ],
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: const Color(0xff8B5CF6).withOpacity(.35),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}