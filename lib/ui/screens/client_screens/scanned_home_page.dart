import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/services/order_service.dart'; // Make sure to import the OrderService
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/ui/custom_widgets/app_layout.dart';
import 'package:splitz/ui/custom_widgets/nav_bar_client.dart';
import 'package:splitz/ui/screens/client_screens/current_order/current_order_screen.dart';
import 'package:splitz/ui/screens/client_screens/menu.dart';
import 'package:splitz/ui/screens/client_screens/scanned_home_body.dart';
import 'package:splitz/ui/screens/client_screens/view_cart.dart';

class ScannedHome extends StatefulWidget {
  const ScannedHome({super.key});

  @override
  _ScannedHomeState createState() => _ScannedHomeState();
}

class _ScannedHomeState extends State<ScannedHome> {
  // Navigator Key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  
  late int _currentIndex;
  void initState() {
    super.initState();

    _currentIndex = 1;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  double _calculateTotalPrice(Order order) {
    //sum of prices of all items in the order
    
      return order.items.fold(
      0.0,
      (total, item) => item.status == 'ordering' ? total + item.price : total,
    );
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
        stream: OrderService().listenToOrdersByUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          double totalPrice = snapshot.data!.fold(
            0.0,
            (total, order) => total + _calculateTotalPrice(order),
          );
         
          var _screens = [
            ScannedHomeBody(
              restaurantId: snapshot.data!.first.restaurantId,
              onNavigateToMenu: () {
                _onTabTapped(2);
              },
            ),
            CurrentOrderScreen(
              orderId: snapshot.data!.first.orderId,
            ),
            MenuScreen(restaurantId: snapshot.data!.first.restaurantId),
          ];

          return Stack(
            children: [
              _screens[_currentIndex],
              if (totalPrice > 0)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: FloatingActionButton.extended(
                   
                      
onPressed: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.98, // Opens to 90% of screen height
      minChildSize: 0.98, // Minimum height (50% of screen)
      maxChildSize: 0.98, // Maximum height (90% of screen)
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const ViewCartScreen(),
      ),
    ),
  );
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
                            const Text('Total', style: TextStyle(color: AppColors.textColor)),
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
                            Icon(Icons.shopping_basket, color: AppColors.textColor),
                            Text('View Order', style: TextStyle(color: AppColors.textColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

  }
}
