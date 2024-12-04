import 'package:flutter/material.dart';

// TODO: Use colors from the app theme
import 'package:splitz/constants/app_colors.dart';

import 'order_item_card__base.dart';
import 'order_item_card_props.dart';

// ignore: camel_case_types
class OrderItemCard_OtherPeopleItem extends StatelessWidget {
  final OrderItemCardProps_Item item;
  final Function() onSharePressed;

  const OrderItemCard_OtherPeopleItem({
    super.key,
    required this.item,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OrderItemCard_Base(item: item),
        Positioned(
          right: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: onSharePressed,
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
              'Share',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
