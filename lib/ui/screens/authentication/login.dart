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
  final _formKey = GlobalKey<FormState>(); // Add the GlobalKey for validation

  // Declare controllers to manage TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable to hold error message
  String? errorMessage;

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
            // Wrap the form fields inside a Form widget
            Form(
              key: _formKey, // Attach the form key
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      // Basic email validation (you can use a more advanced regex here)
                      final regex = RegExp(r'\S+@\S+\.\S+');
                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // No error
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null; // No error
                    },
                  ),
                ],
              ),
            ),
            if (errorMessage == null) const SizedBox(height: 30),
            if (errorMessage != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                child: Text(
                  errorMessage!,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 188, 16, 4),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () async {
                  // Validate the form and show error messages if necessary
                  if (_formKey.currentState?.validate() ?? false) {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    var user = await _auth.signIn(email, password);

                    if (user != null) {
                      print('Login successful: $user');
                      setState(() {
                        errorMessage = null; // Clear any previous error message
                      });
                    } else {
                      print('Login failed');
                      setState(() {
                        errorMessage =
                            'Email or password are incorrect'; // Set the error message
                      });
                    }
                  } else {
                    print('Form validation failed');
                  }
                },
                text: "Login",
              ),
            ),
            const SizedBox(height: 20),
            // If there's an error message, show it

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
            const SizedBox(height: 80),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final user = await _auth.signInWithGoogle();
                  if (user != null) {
                    print(user);
                  } else {
                    print("Google Sign-In canceled or failed");
                  }
                },
                icon: Image.asset(
                  'lib/assets/images/google.png',
                  width: 24,
                  height: 24,
                ),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: AppColors.background),
                  ),
                ),
              ),
            ),
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
