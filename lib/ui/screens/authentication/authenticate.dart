import 'package:flutter/material.dart';
import 'package:splitz/ui/screens/authentication/authentication_landing.dart';
import 'package:splitz/ui/screens/authentication/login.dart';
import 'package:splitz/ui/screens/authentication/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int number = 0;
  void toggleView(int n) {
    setState(() => number = n);
  }

  @override
  Widget build(BuildContext context) {
    if (number == 0)
      return Landing(
        toggleView: toggleView,
      );
    else if (number == 1)
      return Login(toggleView: toggleView);
    else
      return SignUp(toggleView: toggleView);
  }
}
