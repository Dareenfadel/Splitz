import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/manager_screens/cashier_payment/cashier_screen.dart';
import 'package:splitz/ui/screens/manager_screens/cashier_payment/scan_bill_qr_screen.dart';
import 'package:splitz/ui/screens/manager_screens/menu_screens/add_menuItem_Screen.dart';
import 'package:splitz/ui/screens/manager_screens/menu_screens/all_items_screen.dart';
import 'package:splitz/ui/screens/manager_screens/home.dart';
import 'package:splitz/ui/screens/manager_screens/menu_screens/menuItems_of_category_screen.dart';

class ManagerNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = AdminHomePage(restaurantId: user!.restaurantId!);
            break;
          case '/menuItems':
            final args = settings.arguments as Map<String, dynamic>;
            page = CategoryItemsPage(
              restaurantId: args['restaurantId'],
              categoryId: args['categoryId'],
              categoryName: args['categoryName'],
              categoryDescription: args['categoryDescription'],
              categoryImageUrl: args['categoryImageUrl'],
            );
            break;
          // case '/item':
          //   final args = settings.arguments as Map<String, dynamic>;
          //   page = MenuItemScreen(
          //       menuItemId: args["menuItemId"],
          //       restaurantId: args["restaurantId"]);
          case '/add-item':
            final args = settings.arguments as Map<String, dynamic>;
            page = MenuItemForm(
                restaurantId: args["restaurantId"],
                categoryId: args["categoryId"],
                menuItem: args["menuItem"]);
            break;
          case '/all-items':
            final args = settings.arguments as Map<String, dynamic>;
            page = AllItemsScreen(
              restaurantId: args["restaurantId"],
              categoryId: args["categoryId"],
            );
          case '/scan-bill':
            page = ScanBillQrScreen();
            break;
          case '/cashier':
            final args = settings.arguments as Map<String, dynamic>;
            var userId = args['userId'];
            var orderId = args['orderId'];
            page = CashierScreen(
              userId: userId,
              orderId: orderId,
            );
            break;
          default:
            page = AdminHomePage(restaurantId: user!.restaurantId!);
        }
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}
