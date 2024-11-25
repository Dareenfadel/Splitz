import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  String name = "";
  String email = "";
  String password = "";

  // Controller for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await _auth.signInAnnon();
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Sign up to your account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Good to see you again, enter your details below to continue ordering.",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.background,
              ),
            ),
            const SizedBox(height: 40),
            // Name field
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Email field
            TextField(
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Sign up button
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () async {
                  if (name.isNotEmpty &&
                      email.isNotEmpty &&
                      password.isNotEmpty) {
                    // Call the register function for sign up
                    final user = await _auth.register(email, password, name);
                    if (user != null) {
                      print("User signed up successfully: $user");
                    } else {
                      print("Sign up failed");
                    }
                  } else {
                    print("Please fill in all fields");
                  }
                },
                text: "Sign up",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: Divider(color: AppColors.background)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("OR"),
                ),
                Expanded(child: Divider(color: AppColors.background)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                text: "Sign-in with Google",
                onPressed: () async {
                  final user = await _auth.signInWithGoogle();
                  if (user != null) {
                    print(user);
                    // Navigate to another screen or show success
                  } else {
                    print("Google Sign-In canceled or failed");
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  widget.toggleView(1);
                },
                text: "Already have an account? Sign in",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
