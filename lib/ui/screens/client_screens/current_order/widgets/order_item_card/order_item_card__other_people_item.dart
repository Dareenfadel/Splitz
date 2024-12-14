import 'package:flutter/material.dart';

import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import 'order_item_card__base.dart';

// ignore: camel_case_types
class OrderItemCard_OtherPeopleItem extends StatelessWidget {
  final OrderItem item;
  final Map<String, UserModel> orderUsersMap;
  final Function() onSharePressed;

  const OrderItemCard_OtherPeopleItem({
    super.key,
    required this.item,
    required this.orderUsersMap,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OrderItemCard_Base(item: item, orderUsersMap: orderUsersMap),
        _buildShareButton(context),
      ],
    );
  }

  Positioned _buildShareButton(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ElevatedButton(
        onPressed: onSharePressed,
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
          'Join',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
