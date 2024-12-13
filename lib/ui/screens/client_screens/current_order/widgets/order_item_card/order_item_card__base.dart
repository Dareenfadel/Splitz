import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/client_screens/manage_order_item/widgets/splitted_users_list/splitted_users_list.dart';

// ignore: camel_case_types
class OrderItemCard_Base extends StatelessWidget {
  final OrderItem item;
  final Map<String, UserModel> orderUsersMap;
  final double? splitPrice;

  const OrderItemCard_Base(
      {super.key,
      required this.item,
      required this.orderUsersMap,
      this.splitPrice});

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
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
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
                _buildOtherUsersList(context)
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
                    item.itemName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 0),
                  // Description
                  Text(
                    item.notes,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item.price.toStringAsFixed(2)} EGP',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            if (item.status == "ordering")
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  if (MediaQuery.of(context).size.width > 400) ...[
                    const SizedBox(width: 8),
                    Text(
                      'Ordering',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ],
              )
            else if (!item.isFullyPaid)
              Text(
                '${(splitPrice ?? item.sharePrice).toStringAsFixed(2)} EGP',
                style: const TextStyle(
                  fontSize: 18,
                ),
              )
            else
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  if (MediaQuery.of(context).size.width > 400) ...[
                    const SizedBox(width: 8),
                    Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ]
                ],
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildOtherUsersList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Shared With',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SplittedUsersList(
                        users: item.userList,
                        orderUsersMap: orderUsersMap,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...item.userList.take(2).map((user) => _buildOtherUserListItem(user)),
          if (item.userList.length > 2)
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
      ),
    );
  }

  Padding _buildOtherUserListItem(OrderItemUser user) {
    var userModel = orderUsersMap[user.userId]!;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(userModel.imageUrl ?? ''),
        child: Text(
          (userModel.name ?? "Unknown")[0],
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
