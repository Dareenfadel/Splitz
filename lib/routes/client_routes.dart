import 'package:flutter/material.dart';
import 'package:splitz/ui/screens/client_screens/current_order/current_order_screen.dart';

class ClientRoutes {
  static const String currentOrder = '/current-order';
}

class ClientNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments as Map<String, dynamic>;

    switch (settings.name) {
      // case ClientRoutes.currentOrder:
      //   return MaterialPageRoute(
      //       builder: (_) => CurrentOrderScreen(
      //             orderId: args['orderId'],
      //           ));
      default:
        return MaterialPageRoute(
            builder: (_) => Center(
                  child: Text('No route defined for ${settings.name}'),
                )); // Default fallback
    }
  }
}
