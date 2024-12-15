import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart'; // Make sure to import the OrderService
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/ui/custom_widgets/app_layout.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';
import 'package:splitz/ui/custom_widgets/generic_error_screen.dart';
import 'package:splitz/ui/custom_widgets/nav_bar_client.dart';
import 'package:splitz/ui/screens/client_screens/current_order/current_order_screen.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/already_paid_message.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/current_order_layout/current_order_layout.dart';
import 'package:splitz/ui/screens/client_screens/menu.dart';
import 'package:splitz/ui/screens/client_screens/scanned_home_body.dart';
import 'package:splitz/ui/screens/client_screens/view_cart.dart';
import 'package:splitz/ui/screens/shared_screens/account_screen.dart';

class ScannedHome extends StatefulWidget {
  const ScannedHome({super.key});

  @override
  _ScannedHomeState createState() => _ScannedHomeState();
}

class _ScannedHomeState extends State<ScannedHome>
    with SingleTickerProviderStateMixin {
  late TabController _currentOrderTabController;
  late int _currentIndex;

  void initState() {
    super.initState();
    _currentIndex = 0;
    _currentOrderTabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: CurrentOrderLayoutTab.cart,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  double _calculateTotalPrice(Order order) {
    //sum of prices of all items in the order
    var currentUser = context.watch<UserModel>();
    return order.cartTotalForUserId(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = context.watch<UserModel>();

    return DefaultStreamBuilder<List<Order>>(
      stream: OrderService().listenToOrdersByUserId(),
      errorMessage: 'Failed to load orders',
      builder: (List<Order> orders) {
        if (orders.isEmpty) {
          return GenericErrorScreen(
            message: 'No orders found',
          );
        }

        var order = orders.first;

        if (order.userPaid(currentUser.uid)) {
          return AlreadyPaidMessage(
            orderId: order.orderId,
          );
        }

        double totalPrice = orders.fold(
          0.0,
          (total, order) => total + _calculateTotalPrice(order),
        );

        var _screens = [
          ScannedHomeBody(
            restaurantId: orders.first.restaurantId,
            onNavigateToMenu: () {
              _onTabTapped(2);
            },
          ),
          CurrentOrderScreen(
            orderId: orders.first.orderId,
            tabController: _currentOrderTabController,
          ),
          MenuScreen(restaurantId: orders.first.restaurantId),
          AccountScreen(),
        ];

        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: NavBarClient(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
          ),
          body: Stack(
            children: [
              _screens[_currentIndex],
              if (totalPrice > 0 && _currentIndex != 1)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _onTabTapped(1);
                      _currentOrderTabController
                          .animateTo(CurrentOrderLayoutTab.cart);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: AppColors.primary,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Total',
                                style: TextStyle(color: AppColors.textColor)),
                            Text('${totalPrice.toStringAsFixed(2)} EGP',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor)),
                          ],
                        ),
                        const SizedBox(width: 100),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_basket,
                                color: AppColors.textColor),
                            Text('View Order',
                                style: TextStyle(color: AppColors.textColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
