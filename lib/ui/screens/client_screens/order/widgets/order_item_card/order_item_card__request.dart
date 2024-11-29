import 'package:flutter/material.dart';
import 'package:splitz/ui/screens/client_screens/order/widgets/order_item_card/order_item_card_props.dart';

import 'order_item_card__base.dart';

// ignore: camel_case_types
class OrderItemCard_Request extends StatelessWidget {
  final OrderItemCardProps_Item item;
  final OrderItemCardProps_User requestor;

  const OrderItemCard_Request({
    super.key,
    required this.item,
    required this.requestor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25, top: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image
          OrderItemCard_Base(item: item),
          Positioned(
            left: 0,
            right: 0,
            bottom: -28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
          ),

          Positioned(
            left: 0,
            right: 0,
            top: -20,
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
          ),
        ],
      ),
    );
  }
}
