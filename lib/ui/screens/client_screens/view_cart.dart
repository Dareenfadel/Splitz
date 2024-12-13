import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/ui/screens/client_screens/add_to_cart.dart';
import 'package:splitz/constants/app_colors.dart';

class ViewCartScreen extends StatelessWidget {
  const ViewCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_down),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('Order Details', style: TextStyle(color: AppColors.primary)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primary), // Added this line to change back button color
      ),
      
       body: StreamBuilder<List<Order>>(
        stream: orderService.listenToOrdersByUserId(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No items in cart'),
            );
          }

          Order order = snapshot.data!.first;
          List<OrderItem> items = order.items;

          if (items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }
          return Column(
          children: [
            Expanded(
            child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Container(
              height: 120,
              decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
              children: [
              // Image section
                Container(
                width: 100,
                height: 80, // Added fixed height
                margin: const EdgeInsets.all(8), // Added margin for spacing
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // Changed to all corners
                  image: DecorationImage(
                  image: NetworkImage(item.imageUrl ?? 'https://placeholder.com/120'),
                  fit: BoxFit.cover,
                  ),
                ),
                ),
              // Content section
              Expanded(
                child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                // Item name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                    item.itemName,
                    style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                   
                    ),
                  ),
                  Text(
                    '${(item.price).toStringAsFixed(2)}\ EGP',
                    style: TextStyle(
                    fontSize: 18,
                    
                    ),
                  ),
                  ],
                ),
                // Text(
                //   item.notes,
                //   style: TextStyle(
                //   fontSize: 16,
                //   color: Colors.grey[600],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  
               
                  IconButton(
                  icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
                  onPressed: () async {
                    // await orderService.updateItemQuantity(
                    // order.orderId,
                    // index,
                    // item.quantity + 1
                    // );
                  },
                  ),
                  IconButton(
                  icon: Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddToCartScreen(
                      restaurantId: order.restaurantId,
                      orderItemInd: index,
                      orderId: order.orderId,
                      ),
                    ),
                    );
                  },
                  ),
                  IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.primary),
                  onPressed: () async {
                    // await orderService.removeItemFromOrder(
                    // order.orderId,
                    // index,
                    // );
                  },
                  ),
                  ],
                ),
                ],
                ),
                ),
              ),
              ],
              ),
              ),
            );
            },
            ),
            ),
            Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
            ],
            ),
            child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
              'Total:',
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              ),
              ),
             
              Text(
                '${items.where((item) => item.status == 'ordering').fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}\ EGP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
              // await orderService.updateOrderStatus(
              // order.orderId,
              // 'pending',
              // );
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: AppColors.primary,
              ),
              );
              Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              ),
              ),
                child: const Text(
                'Place Order',
                style: TextStyle(color: Colors.white),
                ),
            ),
            ],
            ),
            ),
          ],
          );
        },
      ),
    );
  }
}

