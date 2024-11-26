import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/ui/screens/wrapper.dart';
import 'constants/app_colors.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: Remove this test code

    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.background,
              backgroundColor: AppColors.textColor,
              type:
                  BottomNavigationBarType.fixed, // Prevents shifting animation
            ),
          ),
          home: Wrapper()),
    );
  }
}
