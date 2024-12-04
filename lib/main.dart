import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/ui/screens/wrapper.dart';
import 'package:toastification/toastification.dart';
import 'constants/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: ToastificationWrapper(
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
          home: Wrapper(), // Wrapper is likely checking authentication
        ),
      ),
    );
  }
}
