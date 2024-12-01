import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/data/models/order_item.dart'; // Make sure to import the OrderItem model
import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/services/order_service.dart'; // Make sure to import the OrderService
import 'package:splitz/constants/app_colors.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  // Helper function to calculate the total price for an order
  double _calculateTotalPrice(Order order) {
    return order.items.fold(0.0, (total, item) => total + item.price);
  }

  @override
  Widget build(BuildContext context) {
  // final AuthService _auth = AuthService();
  //   final Stream<UserModel?> user = _auth.user;
  // print(user);
  //   if (user == null) {
      // return Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Orders'),
      //     backgroundColor: Colors.blue, // Replace with your AppColor
      //   ),
      //   body: const Center(
      //     child: Text('Please sign in to view your orders.'),
      //   ),
      // );
    //}

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Home', style: TextStyle(color: Colors.white))),
        backgroundColor: AppColors.primary, 
      ),
      body: StreamBuilder<List<Order>>(
        stream: OrderService().listenToOrdersByUserId(), // Listen to orders for the current user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          // Calculate total price of all orders
          double totalPrice = 0.0;
          for (var order in snapshot.data!) {
            totalPrice += _calculateTotalPrice(order);
          }

          return Column(
            children: [
              // Orders List
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final order = snapshot.data![index];
                    return ListTile(
                      title: Text('Order #${order.orderId}'),
                      subtitle: Text('Table: ${order.tableNumber}, Status: ${order.status}'),
                      trailing: Text('\$${_calculateTotalPrice(order).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
          
            ],
          );
        },
      ),
    );
  }
  
}
