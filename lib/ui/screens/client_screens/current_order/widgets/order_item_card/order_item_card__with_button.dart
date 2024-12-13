import 'package:flutter/material.dart';

import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import 'order_item_card__base.dart';

class OrderItemCard_Props_Button {
  final String? buttonText;
  final IconData? icon;
  final Color? color;
  final Function() onButtonPressed;

  const OrderItemCard_Props_Button(
      {required this.onButtonPressed, this.buttonText, this.icon, this.color});
}

// ignore: camel_case_types
class OrderItemCard_WithButtons extends StatefulWidget {
  final OrderItem item;
  final Map<String, UserModel> ordersUsersMap;
  final List<OrderItemCard_Props_Button> buttons;

  const OrderItemCard_WithButtons({
    super.key,
    required this.item,
    required this.ordersUsersMap,
    required this.buttons,
  });

  @override
  State<OrderItemCard_WithButtons> createState() =>
      _OrderItemCard_WithButtonsState();
}

class _OrderItemCard_WithButtonsState extends State<OrderItemCard_WithButtons> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        OrderItemCard_Base(
          item: widget.item,
          orderUsersMap: widget.ordersUsersMap,
        ),

        _buildButtons(context),
      ],
    );
  }

  Positioned _buildButtons(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Row(
        children: widget.buttons.asMap().entries.map(
          (entry) {
            var index = entry.key;
            var button = entry.value;

            return entry.value.icon != null
                ? _buildIconButton(
                    button,
                    isFirst: index == 0,
                    isLast: index == widget.buttons.length - 1,
                  )
                : _buildTextButton(
                    button,
                    isFirst: index == 0,
                    isLast: index == widget.buttons.length - 1,
                  );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildIconButton(
    OrderItemCard_Props_Button button, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IconButton(
      onPressed: button.onButtonPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.width * 0.03,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: button.color ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: _getBorderRadius(isFirst, isLast),
        ),
      ),
      icon: Icon(
        button.icon,
        color: Colors.white,
        size: MediaQuery.of(context).size.width * 0.05,
      ),
    );
  }

  Widget _buildTextButton(
    OrderItemCard_Props_Button button, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return ElevatedButton(
      onPressed: button.onButtonPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: button.color ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: _getBorderRadius(isFirst, isLast),
        ),
      ),
      child: Text(
        button.buttonText ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius(bool isFirst, bool isLast) {
    if (isFirst && isLast) {
      return const BorderRadius.only(
        topLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      );
    } else if (isFirst) {
      return const BorderRadius.only(
        topLeft: Radius.circular(50),
      );
    } else if (isLast) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(50),
      );
    } else {
      return BorderRadius.zero;
    }
  }
}
