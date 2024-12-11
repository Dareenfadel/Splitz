import 'package:flutter/material.dart';
import 'package:splitz/data/models/user.dart';
import 'package:provider/provider.dart';
import 'package:splitz/routes/manager_routes.dart';
import 'package:splitz/ui/screens/authentication/authenticate.dart';
import 'package:splitz/ui/screens/client_screens/home.dart';
import 'package:splitz/ui/screens/client_screens/scanned_home_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      print(user.userType);
      print(user.currentOrderId);
      print(user.currentOrderId != null && user.currentOrderId!.length > 0);
      if (user.userType == 'manager') {
        return ManagerNavigator();
      } else {
        if (user.currentOrderId != null && user.currentOrderId!.length > 0) {
          print('Scanned Home');
          return ScannedHome();
        } else {
          print('Client Home');
          return ClientHome();
        }
      }
    }
  }
}
