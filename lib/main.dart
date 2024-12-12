import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/screens/wrapper.dart';
import 'package:toastification/toastification.dart';
import 'constants/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // OrderService().addItemToOrder(
  //   restaurantId: 'ZVCMxkUQjp6zcYv6NlYH',
  //   orderId: 'dummy_order',
  //   menuItemId: 'MOq4XxOFYmXyDStd56kh',
  //   originalUserId: 'Yl8hmn486vh2x0QBpUE69Voo3WI3',
  // );

  // OrderService().createOrder(Order(
  //   orderId: 'dummy_order',
  //   restaurantId: 'ZVCMxkUQjp6zcYv6NlYH',
  //   status: 'not paid',
  //   tableNumber: '1',
  //   totalBill: 100,
  //   paidSoFar: 0,
  //   paid: false,
  //   items: [
  //     OrderItem(
  //       itemId: 'lr1zWWeJAV30rtRKbXO2',
  //       itemName: 'fries',
  //       imageUrl: 'https://cloud.appwrite.io/v1/storage/buckets/674fa5a2001133726af4/files/674fafa7e3093bd88287/view?project=674839a900288fa7bb3e&project=674839a900288fa7bb3e&mode=admin',
  //       quantity: 1,
  //       extras: {},
  //       notes: 'No notes',
  //       paidAmount: 0,
  //       paidUsers: {},
  //       prepared: false,
  //       price: 100,
  //       usersList: [
  //         OrderItemUser(
  //           userId: '5vgCa9q5W8NccKV55jFe5OVcW513',
  //           requestStatus: 'accepted'
  //         ),
  //       ],
  //     ),
  //   ],
  //   userIds: [
  //     '5vgCa9q5W8NccKV55jFe5OVcW513',
  //     'Yl8hmn486vh2x0QBpUE69Voo3WI3'
  //   ],
  // ));
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
            colorScheme:
                ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              onPrimary: Colors.white,
              onSecondary: AppColors.primary.withOpacity(0.8),
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.background,
              backgroundColor: AppColors.textColor,
              type:
                  BottomNavigationBarType.fixed, // Prevents shifting animation
            ),
          ),
          home: LoaderOverlay(
            child: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => Wrapper(),
                );
              },
            ),
          ), // Wrapper is likely checking authentication
        ),
      ),
    );
  }
}
