import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

class AuthUi {
  AuthUi._();

  static const Color gold = Color(0xFFFFC94D);
  static const Color goldButton = Color(0xFFFFC83D);
  static const Color ink = Color(0xFF170D18);
  static const Color purple = Color(0xFFE66BFF);
  static const Color success = Color(0xFF42D392);
  static const Color error = Color(0xFFFF6B6B);
}

class AuthPageShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final bool useCard;

  const AuthPageShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(22, 16, 22, 24),
    this.maxWidth = 430,
    this.useCard = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (useCard) {
      content = Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: .08)),
        ),
        child: child,
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SpaceBackground(
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthLogo extends StatelessWidget {
  final double size;
  final String heroTag;

  const AuthLogo({super.key, this.size = 82, this.heroTag = 'logo'});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * .073),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(size * .27),
          border: Border.all(color: Colors.white.withValues(alpha: .11)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * .21),
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;

  const AuthBackButton({super.key, this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        tooltip: 'Back',
        onPressed: enabled
            ? (onPressed ?? () => Navigator.maybePop(context))
            : null,
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: .16),
          side: BorderSide(color: Colors.white.withValues(alpha: .08)),
        ),
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

InputDecoration authInputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffixIcon,
  String? label,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.5),
    hintText: hint,
    hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
    prefixIcon: Icon(icon, color: AuthUi.gold, size: 20),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.black.withValues(alpha: .14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: .08)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: .10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AuthUi.gold, width: 1.2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
    ),
    errorStyle: GoogleFonts.poppins(fontSize: 10.5, height: 1.2),
  );
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthUi.goldButton,
          foregroundColor: AuthUi.ink,
          disabledBackgroundColor: AuthUi.goldButton.withValues(alpha: .65),
          disabledForegroundColor: AuthUi.ink,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: loading
              ? const SizedBox(
                  key: ValueKey('auth_loading'),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: AuthUi.ink,
                  ),
                )
              : Text(
                  label,
                  key: ValueKey<String>(label),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

class AuthOutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  const AuthOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AuthUi.gold,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AuthUi.gold,
          side: BorderSide(color: AuthUi.gold.withValues(alpha: .70)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: child,
      ),
    );
  }
}

void showAuthMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 12.5)),
        backgroundColor: isError
            ? const Color(0xFF8D2434)
            : const Color(0xFF205E46),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
