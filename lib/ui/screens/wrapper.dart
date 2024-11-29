import 'package:flutter/material.dart';
import 'package:splitz/data/models/user.dart';
import 'package:provider/provider.dart';
import 'package:splitz/ui/screens/authentication/authenticate.dart';
import 'package:splitz/ui/screens/client_screens/home.dart';
import 'package:splitz/ui/screens/manager_screens/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null)
      return Authenticate();
    else {
      if (user.userType == 'manager') {
        return AdminHomePage(restaurantId: user.restaurantId ?? '');
      } else {
        return ClientHome();
      }
    }
  }
}
