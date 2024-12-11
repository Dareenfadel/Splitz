import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import '../order_item_card/order_item_card__request.dart';

// ignore: camel_case_types
class CurrentOrderLayout_RequestsTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;
  final Function(int itemIndex) onApprovePressed;
  final Function(int itemIndex) onRejectPressed;

  const CurrentOrderLayout_RequestsTab({
    super.key,
    required this.order,
    required this.orderUsersMap,
    required this.onApprovePressed,
    required this.onRejectPressed,
  });

  @override
  State<CurrentOrderLayout_RequestsTab> createState() =>
      _CurrentOrderLayout_RequestsTabState();
}

// ignore: camel_case_types
class _CurrentOrderLayout_RequestsTabState
    extends State<CurrentOrderLayout_RequestsTab> {
  List<OrderItem> requests = [];

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<UserModel>();
    requests = widget.order.pendingItemsForUserId(currentUser.uid);
    return (requests.isEmpty ? _buildNoItems() : _buildItemsList());
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (context, index) => _buildRequest(requests[index]),
    );
  }

  Padding _buildRequest(OrderItem requestItem) {
    var itemIndex = widget.order.items.indexOf(requestItem);
    var currentUser = context.watch<UserModel>();
    var requestorId = requestItem.getRequestingUserIdFor(currentUser.uid);
    var requestor = widget.orderUsersMap[requestorId]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: OrderItemCard_Request(
        item: requestItem,
        request: requestItem.getRequestFor(currentUser.uid),
        orderUsersMap: widget.orderUsersMap,
        onApprovePressed: () => widget.onApprovePressed(itemIndex),
        onRejectPressed: () => widget.onRejectPressed(itemIndex),
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.request_page,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Requests Yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
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
