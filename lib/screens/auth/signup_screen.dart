import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
//====================================================
// Form
//====================================================

final GlobalKey<FormState> _formKey =
GlobalKey<FormState>();

//====================================================
// Controllers
//====================================================

final TextEditingController firstName =
TextEditingController();

final TextEditingController lastName =
TextEditingController();

final TextEditingController username =
TextEditingController();

final TextEditingController email =
TextEditingController();

final TextEditingController password =
TextEditingController();

final TextEditingController confirmPassword =
TextEditingController();

//====================================================
// Variables
//====================================================

bool loading = false;

bool agree = false;

bool hidePassword = true;

bool hideConfirmPassword = true;

String? gender;

DateTime? dob;

//====================================================
// Dispose
//====================================================

@override
void dispose() {
firstName.dispose();
lastName.dispose();
username.dispose();
email.dispose();
password.dispose();
confirmPassword.dispose();

super.dispose();
}

//====================================================
// Validators
//====================================================

String? validateFirstName(String? value) {
if (value == null || value.trim().isEmpty) {
return 'First name is required';
}

if (value.trim().length < 2) {
return 'Minimum 2 characters';
}

return null;
}

String? validateLastName(String? value) {
if (value == null || value.trim().isEmpty) {
return 'Last name is required';
}

if (value.trim().length < 2) {
return 'Minimum 2 characters';
}

return null;
}

String? validateUsername(String? value) {
if (value == null || value.trim().isEmpty) {
return 'Username is required';
}

final username = value.trim();

if (username.length < 4) {
return 'Minimum 4 characters';
}

if (username.length > 20) {
return 'Maximum 20 characters';
}

final regex = RegExp(r'^[a-zA-Z0-9_.]+$');

if (!regex.hasMatch(username)) {
return 'Only letters, numbers, "_" and "." are allowed';
}

return null;
}

String? validateEmail(String? value) {
if (value == null || value.trim().isEmpty) {
return 'Email is required';
}

final regex = RegExp(
r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
);

if (!regex.hasMatch(value.trim())) {
return 'Enter a valid email';
}

return null;
}

String? validatePassword(String? value) {
if (value == null || value.isEmpty) {
return 'Password is required';
}

if (value.length < 8) {
return 'Minimum 8 characters';
}

if (!RegExp(r'[A-Z]').hasMatch(value)) {
return 'One uppercase letter required';
}

if (!RegExp(r'[a-z]').hasMatch(value)) {
return 'One lowercase letter required';
}

if (!RegExp(r'\d').hasMatch(value)) {
return 'One number required';
}

if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
return 'One special character required';
}

return null;
}

String? validateConfirmPassword(String? value) {
if (value == null || value.isEmpty) {
return 'Confirm your password';
}

if (value != password.text) {
return 'Passwords do not match';
}

return null;
}
//====================================================
// Date Picker
//====================================================

Future<void> _selectDateOfBirth() async {
final DateTime? picked = await showDatePicker(
context: context,
initialDate: DateTime(2000),
firstDate: DateTime(1950),
lastDate: DateTime.now(),
);

if (picked != null) {
setState(() {
dob = picked;
});
}
}

//====================================================
// Input Decoration
//====================================================

InputDecoration _inputDecoration({
required String label,
required String hint,
required IconData icon,
Widget? suffixIcon,
}) {
return InputDecoration(
labelText: label,
hintText: hint,
prefixIcon: Icon(icon),
suffixIcon: suffixIcon,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
),
errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
),
focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(15),
),
);
}

//====================================================
// Sign Up
//====================================================

Future<void> _signUp() async {
FocusScope.of(context).unfocus();

if (loading) return;

if (!_formKey.currentState!.validate()) {
return;
}

if (gender == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please select your gender.'),
),
);
return;
}

if (dob == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please select your date of birth.'),
),
);
return;
}

if (!agree) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Please accept the Terms & Conditions.',
),
),
);
return;
}

setState(() {
loading = true;
});

try {
final credential = await AuthService.instance.signUp(
fullName:
'${firstName.text.trim()} ${lastName.text.trim()}',
username: username.text.trim().toLowerCase(),
email: email.text.trim().toLowerCase(),
password: password.text.trim(),
);

if (credential.user != null) {
await FirestoreService.instance.updateOnlineStatus(
credential.user!.uid,
true,
);
}

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Account created successfully. Verify your email.',
),
),
);

Navigator.pushReplacementNamed(
context,
AppRoutes.emailVerification,
);
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
e.toString().replaceFirst(
'Exception: ',
'',
),
),
),
);
} finally {
if (mounted) {
setState(() {
loading = false;
});
}
}
}

//====================================================
// Build
//====================================================

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: () => FocusScope.of(context).unfocus(),
child: Scaffold(
  backgroundColor: AppColors.background,
resizeToAvoidBottomInset: true,
body: SafeArea(
child: Form(
key: _formKey,
autovalidateMode:
AutovalidateMode.onUserInteraction,
child: ListView(
padding: const EdgeInsets.all(24),
children: [
//====================================================
// Header
//====================================================

const SizedBox(height: 10),

const Icon(
Icons.account_circle,
size: 90,
),

const SizedBox(height: 20),

const Text(
'Create Account',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

const Text(
'Create your JUNAYA account',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 15,
color: Colors.grey,
),
),

const SizedBox(height: 35),

//====================================================
// First Name
//====================================================

TextFormField(
controller: firstName,
validator: validateFirstName,
textInputAction: TextInputAction.next,
textCapitalization: TextCapitalization.words,
decoration: _inputDecoration(
label: 'First Name',
hint: 'Enter first name',
icon: Icons.person_outline,
),
),

const SizedBox(height: 18),

//====================================================
// Last Name
//====================================================

TextFormField(
controller: lastName,
validator: validateLastName,
textInputAction: TextInputAction.next,
textCapitalization: TextCapitalization.words,
decoration: _inputDecoration(
label: 'Last Name',
hint: 'Enter last name',
icon: Icons.badge_outlined,
),
),

const SizedBox(height: 18),

//====================================================
// Username
//====================================================

TextFormField(
controller: username,
validator: validateUsername,
textInputAction: TextInputAction.next,
textCapitalization: TextCapitalization.none,
decoration: _inputDecoration(
label: 'Username',
hint: 'Choose a username',
icon: Icons.alternate_email,
),
),

const SizedBox(height: 18),

//====================================================
// Email
//====================================================

TextFormField(
controller: email,
validator: validateEmail,
keyboardType: TextInputType.emailAddress,
textInputAction: TextInputAction.next,
textCapitalization: TextCapitalization.none,
autofillHints: const [
AutofillHints.email,
],
decoration: _inputDecoration(
label: 'Email',
hint: 'Enter your email',
icon: Icons.email_outlined,
),
),

const SizedBox(height: 18),
//====================================================
// Gender
//====================================================

DropdownButtonFormField<String>(
initialValue: gender,
decoration: _inputDecoration(
label: 'Gender',
hint: 'Select your gender',
icon: Icons.person,
),
items: const [
DropdownMenuItem(
value: 'Male',
child: Text('Male'),
),
DropdownMenuItem(
value: 'Female',
child: Text('Female'),
),
DropdownMenuItem(
value: 'Other',
child: Text('Other'),
),
],
onChanged: (value) {
setState(() {
gender = value;
});
},
),

const SizedBox(height: 18),

//====================================================
// Date of Birth
//====================================================

InkWell(
borderRadius: BorderRadius.circular(15),
onTap: _selectDateOfBirth,
child: InputDecorator(
decoration: _inputDecoration(
label: 'Date of Birth',
hint: 'Select your date of birth',
icon: Icons.calendar_month_outlined,
),
child: Text(
dob == null
? 'Select your date of birth'
: '${dob!.day}/${dob!.month}/${dob!.year}',
style: TextStyle(
color: dob == null
? Colors.grey
: Theme.of(context).textTheme.bodyLarge?.color,
),
),
),
),

const SizedBox(height: 18),

//====================================================
// Password
//====================================================

TextFormField(
controller: password,
validator: validatePassword,
obscureText: hidePassword,
textInputAction: TextInputAction.next,
autofillHints: const [
AutofillHints.newPassword,
],
decoration: _inputDecoration(
label: 'Password',
hint: 'Create a strong password',
icon: Icons.lock_outline,
suffixIcon: IconButton(
icon: Icon(
hidePassword
? Icons.visibility_off
: Icons.visibility,
),
onPressed: () {
setState(() {
hidePassword = !hidePassword;
});
},
),
),
),

const SizedBox(height: 18),

//====================================================
// Confirm Password
//====================================================

TextFormField(
controller: confirmPassword,
validator: validateConfirmPassword,
obscureText: hideConfirmPassword,
textInputAction: TextInputAction.done,
autofillHints: const [
AutofillHints.newPassword,
],
onFieldSubmitted: (_) => _signUp(),
decoration: _inputDecoration(
label: 'Confirm Password',
hint: 'Re-enter your password',
icon: Icons.lock_outline,
suffixIcon: IconButton(
icon: Icon(
hideConfirmPassword
? Icons.visibility_off
: Icons.visibility,
),
onPressed: () {
setState(() {
hideConfirmPassword =
!hideConfirmPassword;
});
},
),
),
),

const SizedBox(height: 24),
//====================================================
// Terms & Conditions
//====================================================

CheckboxListTile(
value: agree,
controlAffinity: ListTileControlAffinity.leading,
contentPadding: EdgeInsets.zero,
activeColor: Theme.of(context).primaryColor,
title: const Text(
'I agree to the Terms & Conditions and Privacy Policy',
style: TextStyle(fontSize: 14),
),
onChanged: (value) {
setState(() {
agree = value ?? false;
});
},
),

const SizedBox(height: 30),

//====================================================
// Create Account Button
//====================================================

SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
onPressed: loading ? null : _signUp,
style: ElevatedButton.styleFrom(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),
),
),
child: loading
? const SizedBox(
width: 22,
height: 22,
child: CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
)
: const Text(
'Create Account',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
),

const SizedBox(height: 25),

//====================================================
// Already have an account?
//====================================================

Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
"Already have an account?",
),
TextButton(
onPressed: loading
? null
: () {
Navigator.pushReplacementNamed(
context,
AppRoutes.login,
);
},
child: const Text(
"Sign In",
),
),
],
),

const SizedBox(height: 20),
],
),
),
),
),
);
}
}