import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__base.dart';

class AlreadyPaidMessage extends StatelessWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;

  const AlreadyPaidMessage({
    super.key,
    required this.order,
    required this.orderUsersMap,
  });

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<UserModel>();
    var userItems = order.acceptedItemsForUserId(currentUser.uid);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 24),
            const Text(
              'You have already paid for this order.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: userItems.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: OrderItemCard_Base(
                  item: userItems[index],
                  orderUsersMap: orderUsersMap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
