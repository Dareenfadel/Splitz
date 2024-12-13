import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/custom_widgets/message_container.dart';

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

  Widget _buildNoItems() {
    return const MessageContainer(
      icon: Icons.request_page,
      message: 'No Requests Yet!',
      subMessage:
          'When others request to join your orders, they will appear here.',
    );
  }
}
