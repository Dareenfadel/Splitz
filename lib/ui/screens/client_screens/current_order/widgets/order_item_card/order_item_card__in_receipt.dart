import 'package:flutter/material.dart';

// TODO: Use colors from the app theme
import 'package:splitz/constants/app_colors.dart';

import 'order_item_card__base.dart';
import 'order_item_card_props.dart';

// ignore: camel_case_types
class OrderItemCard_InReceipt extends StatelessWidget {
  final OrderItemCardProps_Item item;
  final Function() onManagePressed;

  const OrderItemCard_InReceipt({
    super.key,
    required this.item,
    required this.onManagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        OrderItemCard_Base(item: item),
        Positioned(
          right: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: onManagePressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: AppColors.primary,
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
        ),

        if (item.sharedWith.any((user) => user.pendingApproval))
          Positioned(
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
              )),
      ],
    );
  }
}
