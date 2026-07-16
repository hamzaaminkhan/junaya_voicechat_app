import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
final _formKey = GlobalKey<FormState>();

final firstName = TextEditingController();
final lastName = TextEditingController();
final email = TextEditingController();
final password = TextEditingController();
final confirmPassword = TextEditingController();

bool agree = false;
bool loading = false;

bool hidePassword = true;
bool hideConfirm = true;

String? gender;
DateTime? dob;

// ==========================
// Validation Methods
// ==========================

String? validateFirstName(String? value) {
if (value == null || value.trim().isEmpty) {
return "First name is required";
}

if (value.trim().length < 2) {
return "Minimum 2 characters";
}

return null;
}

String? validateLastName(String? value) {
if (value == null || value.trim().isEmpty) {
return "Last name is required";
}

if (value.trim().length < 2) {
return "Minimum 2 characters";
}

return null;
}

String? validateEmail(String? value) {
if (value == null || value.trim().isEmpty) {
return "Email is required";
}

final emailRegex = RegExp(
r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
);

if (!emailRegex.hasMatch(value.trim())) {
return "Enter a valid email";
}

return null;
}

String? validatePassword(String? value) {
if (value == null || value.isEmpty) {
return "Password is required";
}

if (value.length < 8) {
return "Minimum 8 characters";
}

if (!RegExp(r'[A-Z]').hasMatch(value)) {
return "Must contain one uppercase letter";
}

if (!RegExp(r'[a-z]').hasMatch(value)) {
return "Must contain one lowercase letter";
}

if (!RegExp(r'\d').hasMatch(value)) {
return "Must contain one number";
}

return null;
}

String? validateConfirmPassword(String? value) {
if (value == null || value.isEmpty) {
return "Please confirm your password";
}

if (value != password.text) {
return "Passwords do not match";
}

if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
  return "Must contain one special character";
}

return null;
}

@override
void dispose() {
firstName.dispose();
lastName.dispose();
email.dispose();
password.dispose();
confirmPassword.dispose();
super.dispose();
}

Future<void> signup() async {
if (!_formKey.currentState!.validate()) return;

if (!agree) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Please accept Privacy Policy"),
),
);
return;
}

if (gender == null || dob == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Select gender and birth date"),
),
);
return;
}

setState(() => loading = true);

try {
final cred =
await FirebaseAuth.instance.createUserWithEmailAndPassword(
email: email.text.trim(),
password: password.text.trim(),
);
await FirebaseFirestore.instance
.collection("users")
.doc(cred.user!.uid)
.set({
"uid": cred.user!.uid,
"firstName": firstName.text.trim(),
"lastName": lastName.text.trim(),
"email": email.text.trim(),
"gender": gender,
"dob": dob!.toIso8601String(),
"coins": 0,
"diamonds": 0,
"vip": false,
"createdAt": FieldValue.serverTimestamp(),
});

if (!mounted) return;
Navigator.pushReplacementNamed(context, AppRoutes.home);
} on FirebaseAuthException catch (e) {
  String message;

  switch (e.code) {
    case 'email-already-in-use':
      message = 'An account already exists with this email.';
      break;

    case 'invalid-email':
      message = 'Please enter a valid email address.';
      break;

    case 'weak-password':
      message = 'Password is too weak.';
      break;

    case 'operation-not-allowed':
      message = 'Email & Password sign-in is disabled.';
      break;

    case 'network-request-failed':
      message = 'No internet connection.';
      break;

    default:
      message = e.message ?? 'Registration failed.';
  }

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
} catch (_) {
  if (!mounted) return;


  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Something went wrong. Please try again.'),
    ),
  );
}

finally {
if (mounted) {
setState(() => loading = false);
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Sign Up"),
),
body: Form(
key: _formKey,
autovalidateMode: AutovalidateMode.onUserInteraction,
child: ListView(
padding: const EdgeInsets.all(20),
children: [

// First Name
TextFormField(
controller: firstName,
textInputAction: TextInputAction.next,
decoration: const InputDecoration(
labelText: "First Name",
hintText: "Enter your first name",
),
validator: validateFirstName,
),

const SizedBox(height: 16),

// Last Name
TextFormField(
controller: lastName,
textInputAction: TextInputAction.next,
decoration: const InputDecoration(
labelText: "Last Name",
hintText: "Enter your last name",
),
validator: validateLastName,
),

const SizedBox(height: 16),

// Email
  TextFormField(
    controller: email,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    autocorrect: false,
    enableSuggestions: false,
    decoration: const InputDecoration(
      labelText: "Email",
      hintText: "example@email.com",
    ),
    validator: validateEmail,
  ),

const SizedBox(height: 16),

// Password
TextFormField(
controller: password,
obscureText: hidePassword,
textInputAction: TextInputAction.next,
decoration: InputDecoration(
labelText: "Password",
hintText: "Enter your password",
suffixIcon: IconButton(
icon: Icon(
hidePassword
? Icons.visibility
: Icons.visibility_off,
),
onPressed: () {
setState(() {
hidePassword = !hidePassword;
});
},
),
),
validator: validatePassword,
),

const SizedBox(height: 16),

  // Confirm Password
  TextFormField(
    controller: confirmPassword,
    obscureText: hideConfirm,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      labelText: "Confirm Password",
      hintText: "Re-enter your password",
      suffixIcon: IconButton(
        icon: Icon(
          hideConfirm
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            hideConfirm = !hideConfirm;
          });
        },
      ),
    ),
    validator: validateConfirmPassword,
  ),

  const SizedBox(height: 20),

  // Gender
  Wrap(
    spacing: 8,
    runSpacing: 8,
    children: ["Male", "Female", "Other"]
        .map(
          (g) => ChoiceChip(
        label: Text(g),
        selected: gender == g,
        onSelected: (_) {
          setState(() {
            gender = g;
          });
        },
      ),
    )
        .toList(),
  ),

  const SizedBox(height: 20),

  // Date of Birth
  ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      dob == null
          ? "Select Birth Date"
          : "${dob!.day}/${dob!.month}/${dob!.year}",
    ),
    trailing: const Icon(Icons.calendar_today),
    onTap: () async {
      final selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        initialDate: DateTime(2000),
      );

      if (selectedDate != null) {
        setState(() {
          dob = selectedDate;
        });
      }
    },
  ),

  const SizedBox(height: 10),

  // Privacy Policy
  CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    value: agree,
    onChanged: (value) {
      setState(() {
        agree = value ?? false;
      });
    },
    controlAffinity: ListTileControlAffinity.leading,
    title: const Text(
      "I agree to the Privacy Policy",
    ),
  ),

  const SizedBox(height: 25),

  // Sign Up Button
  SizedBox(
    height: 55,
    child: ElevatedButton(
      onPressed: loading ? null : signup,
      child: loading
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
        ),
      )
          : const Text(
        "Sign Up",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
],
),
),
);
}
}

Widget dateBox(String text) {
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