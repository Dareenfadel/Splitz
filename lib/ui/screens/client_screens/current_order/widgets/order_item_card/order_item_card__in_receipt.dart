import 'package:flutter/material.dart';

import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import 'order_item_card__base.dart';

// ignore: camel_case_types
class OrderItemCard_InReceipt extends StatelessWidget {
  final OrderItem item;
  final Map<String, UserModel> ordersUsersMap;
  final Function() onManagePressed;

  const OrderItemCard_InReceipt({
    super.key,
    required this.item,
    required this.onManagePressed,
    required this.ordersUsersMap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        OrderItemCard_Base(
          item: item,
          orderUsersMap: ordersUsersMap,
        ),
        
        _buildManageButton(context),

        if (item.usersList.any((user) => user.requestStatus == "pending"))
          _buildPendingRequestIndicator(),
      ],
    );
  }

  Positioned _buildManageButton(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ElevatedButton(
        onPressed: onManagePressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        child: const Text(
          'Manage',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Positioned _buildPendingRequestIndicator() {
    return Positioned(
        top: 20,
        right: 20,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.hourglass_top_rounded,
            size: 16,
            color: Colors.grey[600],
          ),
        ));
  }
}
