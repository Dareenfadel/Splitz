import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/models/user.dart';

class SplittedUsersList extends StatelessWidget {
  final List<OrderItemUser> users;
  final Map<String, UserModel> orderUsersMap;

  const SplittedUsersList({
    super.key,
    required this.users,
    required this.orderUsersMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users
          .map(
            (user) => _buildItem(user),
          )
          .toList(),
    );
  }

  Padding _buildItem(OrderItemUser user) {
    var userModel = orderUsersMap[user.userId]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userModel.imageUrl ?? ''),
                radius: 32,
                backgroundColor: AppColors.secondary,
                child: Text(
                  (userModel.name ?? 'Unknown')[0],
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Text(
                    userModel.name ?? "Unknown",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              if (user.requestStatus == 'pending')
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.hourglass_top_rounded,
                      size: 16, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
