import 'package:flutter/material.dart';

import 'order_item_card_props.dart';

// ignore: camel_case_types
class OrderItemCard_Base extends StatelessWidget {
  final OrderItemCardProps_Item item;

  const OrderItemCard_Base({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(color: Colors.black.withOpacity(0.1), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 25, 30),
        child: Row(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.network(
                    item.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.restaurant,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...item.sharedWith.take(2).map((user) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(user.imageUrl),
                            child: Text(
                              user.name[0],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                    if (item.sharedWith.length > 2)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[300],
                        child: const Center(
                            child: Icon(
                          Icons.more_horiz,
                          size: 12,
                          color: Colors.grey,
                        )),
                      ),
                  ],
                )
              ],
            ),
            const SizedBox(width: 16),
            // Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Burger Title
                  Text(
                    item.title,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 0),
                  // Description
                  Text(
                    item.notes,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Old Price
                  Text(
                    '${item.totalPrice} EGP',
                    style: const TextStyle(fontSize: 14, color: Colors.pink),
                  ),
                ],
              ),
            ),
            Text(
              '${item.sharePrice} EGP',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
