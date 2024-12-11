import 'package:flutter/material.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/models/user.dart';

import 'order_item_card__base.dart';

// ignore: camel_case_types
class OrderItemCard_Request extends StatelessWidget {
  final OrderItem item;
  final OrderItemUser request;
  final Map<String, UserModel> orderUsersMap;

  final Function() onApprovePressed;
  final Function() onRejectPressed;

  const OrderItemCard_Request({
    super.key,
    required this.item,
    required this.onApprovePressed,
    required this.onRejectPressed,
    required this.request,
    required this.orderUsersMap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Image
        Padding(
          padding: const EdgeInsets.only(bottom: 25, top: 25),
          child: OrderItemCard_Base(
            item: item,
            orderUsersMap: orderUsersMap,
          ),
        ),
        _buildAcceptRejectButtons(),
        _buildHeaderMessage(),
      ],
    );
  }

  Positioned _buildHeaderMessage() {
    var requestor = orderUsersMap[request.requestedBy]!;

    return Positioned(
      left: 0,
      right: 0,
      top: 5,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${requestor.name} wants to share this with you',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildAcceptRejectButtons() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              onRejectPressed();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.red[100],
              shape: const CircleBorder(),
              elevation: 4,
            ),
            child: Icon(Icons.close, color: Colors.red[900]),
          ),
          ElevatedButton(
            onPressed: () {
              onApprovePressed();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.green[100],
              shape: const CircleBorder(),
              elevation: 4,
            ),
            child: Icon(Icons.check, color: Colors.green[900]),
          ),
        ],
      ),
    );
  }
}
