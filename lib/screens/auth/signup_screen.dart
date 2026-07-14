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
        const SnackBar(content: Text("Please accept Privacy Policy")),
      );
      return;
    }

    if (gender == null || dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select gender and birth date")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Signup failed")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: firstName,
              decoration: const InputDecoration(labelText: "First Name"),
              validator: (v)=>v!.isEmpty?"Required":null,
            ),
            TextFormField(
              controller: lastName,
              decoration: const InputDecoration(labelText: "Last Name"),
              validator: (v)=>v!.isEmpty?"Required":null,
            ),
            TextFormField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (v)=>v!.contains("@")?null:"Invalid email",
            ),
            TextFormField(
              controller: password,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(hidePassword?Icons.visibility:Icons.visibility_off),
                  onPressed: ()=>setState(()=>hidePassword=!hidePassword),
                ),
              ),
              validator: (v)=>v!=null&&v.length>=6?null:"Minimum 6 characters",
            ),
            TextFormField(
              controller: confirmPassword,
              obscureText: hideConfirm,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                suffixIcon: IconButton(
                  icon: Icon(hideConfirm?Icons.visibility:Icons.visibility_off),
                  onPressed: ()=>setState(()=>hideConfirm=!hideConfirm),
                ),
              ),
              validator: (v)=>v==password.text?null:"Passwords don't match",
            ),
            const SizedBox(height:16),
            Wrap(
              spacing:8,
              children:["Male","Female","Other"].map((g)=>ChoiceChip(
                label: Text(g),
                selected: gender==g,
                onSelected: (_)=>setState(()=>gender=g),
              )).toList(),
            ),
            const SizedBox(height:16),
            ListTile(
              title: Text(dob==null?"Select Birth Date":"${dob!.day}/${dob!.month}/${dob!.year}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async{
                final d=await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: DateTime(2000),
                );
                if(d!=null)setState(()=>dob=d);
              },
            ),
            CheckboxListTile(
              value: agree,
              onChanged: (v)=>setState(()=>agree=v!),
              title: const Text("I agree to Privacy Policy"),
            ),
            ElevatedButton(
              onPressed: loading?null:signup,
              child: loading?const CircularProgressIndicator():const Text("Sign Up"),
            )
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
