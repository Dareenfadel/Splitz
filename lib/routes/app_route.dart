// import 'package:flutter/material.dart';
// import 'package:splitz/ui/screens/manager_screens/account_screen.dart';
// import 'package:splitz/ui/screens/manager_screens/history_screen.dart';
// import 'package:splitz/ui/screens/manager_screens/menu_screen.dart';
// import 'package:splitz/ui/screens/manager_screens/orders_screen.dart';

// // Define your routes as constants for easy reference
// class AppRoutes {
//   static const String orders = '/orders';
//   static const String history = '/history';
//   static const String menu = '/menu';
//   static const String account = '/account';
// }

// // App route settings for navigation
// class AppNavigation {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case AppRoutes.orders:
//         return MaterialPageRoute(builder: (_) => OrdersScreen());
//       case AppRoutes.history:
//         return MaterialPageRoute(builder: (_) => HistoryScreen());
//       case AppRoutes.menu:
//         return MaterialPageRoute(builder: (_) => MenuScreen());
//       case AppRoutes.account:
//         return MaterialPageRoute(builder: (_) => AccountScreen());
//       default:
//         return MaterialPageRoute(
//             builder: (_) => OrdersScreen()); // Default fallback
//     }
//   }
// }
