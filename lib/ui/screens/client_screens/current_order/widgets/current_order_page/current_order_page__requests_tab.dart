import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import '../order_item_card/order_item_card__request.dart';
import '../order_item_card/order_item_card_props.dart';

// ignore: camel_case_types
class CurrentOrderPage_RequestsTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;
  final Function(int itemIndex) onApprovePressed;
  final Function(int itemIndex) onRejectPressed;

  const CurrentOrderPage_RequestsTab({
    super.key,
    required this.order,
    required this.orderUsersMap,
    required this.onApprovePressed,
    required this.onRejectPressed,
  });

  @override
  State<CurrentOrderPage_RequestsTab> createState() =>
      _CurrentOrderPage_RequestsTabState();
}

// ignore: camel_case_types
class _CurrentOrderPage_RequestsTabState
    extends State<CurrentOrderPage_RequestsTab> {
  late final List<OrderItem> requests;

  @override
  void initState() {
    super.initState();
    var currentUser = context.read<UserModel>();
    requests = widget.order.pendingItemsForUserId(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return (requests.isEmpty ? _buildNoItems() : _buildItemsList());
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (context, index) => _buildRequest(index),
    );
  }

  Padding _buildRequest(int index) {
    var request = requests[index];
    var currentUser = context.watch<UserModel>();
    var requestorId = request.getRequestingUserIdFor(currentUser.uid);
    var requestor = widget.orderUsersMap[requestorId]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: OrderItemCard_Request(
        item: OrderItemCardProps_Item.fromOrderItem(
          item: request,
          usersMap: widget.orderUsersMap,
        ),
        requestor: OrderItemCardProps_User.fromUserModel(requestor),
        onApprovePressed: () => widget.onApprovePressed(index),
        onRejectPressed: () => widget.onRejectPressed(index),
      ),
    );
  }

  Center _buildNoItems() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.request_page,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Requests Yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'When others request to join your orders, they will appear here.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
