import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({required this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();

  // Declare controllers to manage TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Don't forget to dispose of controllers when done
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              "Login to your account",
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
            // Use TextEditingController to retrieve values
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  if (email.isNotEmpty && password.isNotEmpty) {
                    var user = await _auth.signIn(email, password);

                    if (user != null) {
                      print('Login successful: $user');
                    } else {
                      print('Login failed');
                    }
                  } else {
                    print('Email and password cannot be empty');
                  }
                },
                text: "Login",
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
                    })),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  widget.toggleView(2); // Trigger the toggle view callback
                },
                text: "Create an account",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
