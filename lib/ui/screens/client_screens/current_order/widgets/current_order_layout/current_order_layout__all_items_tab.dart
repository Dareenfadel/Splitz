import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_type.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__base.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__request.dart';

import '../order_item_card/order_item_card__in_receipt.dart';
import '../order_item_card/order_item_card__other_people_item.dart';

// ignore: camel_case_types
class CurrentOrderLayout_AllItemsTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> ordersUsersMap;
  final Function(int itemIndex) onManagePressed;
  final Function(int itemIndex) onSharePressed;
  final Function(int itemIndex) onAcceptPressed;
  final Function(int itemIndex) onRejectPressed;

  const CurrentOrderLayout_AllItemsTab({
    super.key,
    required this.onManagePressed,
    required this.onSharePressed,
    required this.order,
    required this.ordersUsersMap,
    required this.onAcceptPressed,
    required this.onRejectPressed,
  });

  @override
  State<CurrentOrderLayout_AllItemsTab> createState() =>
      _CurrentOrderLayout_AllItemsTabState();
}

// ignore: camel_case_types
class _CurrentOrderLayout_AllItemsTabState
    extends State<CurrentOrderLayout_AllItemsTab> {
  late UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<UserModel>();
    return (widget.order.items.isEmpty ? _buildNoItems() : _buildItemsList());
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: widget.order.items.length,
      itemBuilder: (context, index) => _buildItem(index),
    );
  }

  Widget _buildItem(int itemIndex) {
    var item = widget.order.items[itemIndex];
    var itemType = item.itemTypeForUserId(currentUser.uid);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: switch (itemType) {
        OrderItemType.fullyPaid => _buildFullyPaidItem(item),
        OrderItemType.request => _buildRequestItem(item),
        OrderItemType.otherPeopleItem => _buildOtherPeopleItem(item),
        OrderItemType.myItem => _buildMyItem(item),
      },
    );
  }

  _buildFullyPaidItem(OrderItem item) {
    return OrderItemCard_Base(
      item: item,
      orderUsersMap: widget.ordersUsersMap,
    );
  }

  OrderItemCard_Request _buildRequestItem(OrderItem item) {
    var itemIndex = widget.order.items.indexOf(item);

    return OrderItemCard_Request(
      item: item,
      request: item.userList.firstWhere(
        (element) => element.userId == currentUser.uid,
      ),
      orderUsersMap: widget.ordersUsersMap,
      onApprovePressed: () => widget.onAcceptPressed(itemIndex),
      onRejectPressed: () => widget.onRejectPressed(itemIndex),
    );
  }

  OrderItemCard_OtherPeopleItem _buildOtherPeopleItem(OrderItem item) {
    var itemIndex = widget.order.items.indexOf(item);

    return OrderItemCard_OtherPeopleItem(
      item: item,
      orderUsersMap: widget.ordersUsersMap,
      onSharePressed: () => widget.onSharePressed(itemIndex),
    );
  }

  Widget _buildMyItem(OrderItem item) {
    var itemIndex = widget.order.items.indexOf(item);

    return OrderItemCard_InReceipt(
      item: item,
      ordersUsersMap: widget.ordersUsersMap,
      onManagePressed: () => widget.onManagePressed(itemIndex),
    );
  }

  Widget _buildNoItems() {
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
              Icons.restaurant_menu,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Orders Yet!',
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
              'When people start adding items to the order, they will appear here.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // const SizedBox(height: 24),
          // ElevatedButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.add_circle_outline),
          //   label: const Text('Add First Item'),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(
          //         horizontal: 24, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
