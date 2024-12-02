import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/data/models/order_item.dart'; // Make sure to import the OrderItem model
import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/services/order_service.dart'; // Make sure to import the OrderService
import 'package:splitz/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:splitz/ui/custom_widgets/nav_bar_client.dart';
import 'package:splitz/ui/screens/client_screens/menu.dart';
import 'package:splitz/ui/screens/client_screens/orders.dart';
import 'package:splitz/ui/screens/client_screens/scanned_home_body.dart';
import 'package:splitz/ui/screens/client_screens/scanned_home_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late int _currentIndex;
  void initState() {
    super.initState();

    _currentIndex = 0;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: NavBarClient(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      body: StreamBuilder<List<Order>>(
        stream: OrderService()
            .listenToOrdersByUserId(), // Listen to orders for the current user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          // Calculate total price of all orders
          double totalPrice = snapshot.data!.fold(
            0.0,
            (total, order) => total + _calculateTotalPrice(order),
          );
          var _screens = [
            ScannedHomeBody(restaurantId: snapshot.data!.first.restaurantId),
            MenuScreen(restaurantId: snapshot.data!.first.restaurantId),
            OrdersScreen()
          ];
          return Column(
            children: [
              // Orders List
              Expanded(
                child: _screens[_currentIndex],
              ),
              // Floating Action Button
              if (totalPrice > 0)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/qr_scan');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: AppColors.primary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Total',
                                  style: const TextStyle(
                                      color: AppColors.textColor)),
                              Text('${totalPrice.toStringAsFixed(2)} EGP',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ],
                          ),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_basket,
                                  color: AppColors.textColor),
                              Text('View Order',
                                  style: const TextStyle(
                                      color: AppColors.textColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  double _calculateTotalPrice(Order order) {
    return order.totalBill;
  }
}
