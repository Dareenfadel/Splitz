import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_type.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/custom_widgets/message_container.dart';
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
  final Function() onSplitEquallyPressed;

  const CurrentOrderLayout_AllItemsTab({
    super.key,
    required this.onManagePressed,
    required this.onSharePressed,
    required this.order,
    required this.ordersUsersMap,
    required this.onAcceptPressed,
    required this.onRejectPressed,
    required this.onSplitEquallyPressed,
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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.order.items.length,
            itemBuilder: (context, index) => _buildItem(index),
          ),
        ),
        if (widget.order.nonPaidUserIds.length > 1)
          _buildSplitEquallyContainer(),
      ],
    );
  }

  Container _buildSplitEquallyContainer() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.order.nonOrderingItems.length > 0
                ? widget.onSplitEquallyPressed
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            icon: const Icon(Icons.currency_exchange, color: Colors.white),
            label: const Text(
              'Split Equally',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ));
  }

  Widget _buildItem(int itemIndex) {
    var item = widget.order.items[itemIndex];
    var itemType = item.itemTypeForUserId(currentUser.uid);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: switch (itemType) {
        OrderItemType.ordering => _buildBaseItem(item),
        OrderItemType.fullyPaid => _buildBaseItem(item),
        OrderItemType.request => _buildRequestItem(item),
        OrderItemType.otherPeopleItem => _buildOtherPeopleItem(item),
        OrderItemType.myItem => _buildMyItem(item),
      },
    );
  }

  _buildBaseItem(OrderItem item) {
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
    return const MessageContainer(
      icon: Icons.restaurant_menu,
      message: 'No Orders Yet!',
      subMessage:
          'When people start adding items to the order, they will appear here.',
    );
  }
}
