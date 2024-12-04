import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_type.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__request.dart';

import '../order_item_card/order_item_card__in_receipt.dart';
import '../order_item_card/order_item_card__other_people_item.dart';
import '../order_item_card/order_item_card_props.dart';

// ignore: camel_case_types
class CurrentOrderPage_AllItemsTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> ordersUsersMap;
  final Function(int itemIndex) onManagePressed;
  final Function(int itemIndex) onSharePressed;
  final Function(int itemIndex) onAcceptPressed;
  final Function(int itemIndex) onRejectPressed;

  const CurrentOrderPage_AllItemsTab({
    super.key,
    required this.onManagePressed,
    required this.onSharePressed,
    required this.order,
    required this.ordersUsersMap,
    required this.onAcceptPressed,
    required this.onRejectPressed,
  });

  @override
  State<CurrentOrderPage_AllItemsTab> createState() =>
      _CurrentOrderPage_AllItemsTabState();
}

// ignore: camel_case_types
class _CurrentOrderPage_AllItemsTabState
    extends State<CurrentOrderPage_AllItemsTab> {
  late UserModel currentUser;

  @override
  Widget build(BuildContext context) {
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
    var currentUser = context.watch<UserModel>();
    var itemType = item.itemTypeForUserId(currentUser.uid);
    var widgetMap = {
      OrderItemType.request: _buildRequestItem(itemIndex),
      OrderItemType.otherPeopleItem: _buildOtherPeopleItem(itemIndex),
      OrderItemType.myItem: _buildMyItem(itemIndex),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: widgetMap[itemType],
    );
  }

  OrderItemCard_Request _buildRequestItem(int itemIndex) {
    var currentUser = context.watch<UserModel>();
    var item = widget.order.items[itemIndex];

    return OrderItemCard_Request(
      item: OrderItemCardProps_Item.fromOrderItem(
        item: item,
        usersMap: widget.ordersUsersMap,
      ),
      requestor: OrderItemCardProps_User.fromUserModel(
        widget.ordersUsersMap[item.getRequestingUserIdFor(currentUser.uid)]!,
      ),
      onApprovePressed: () => widget.onAcceptPressed(itemIndex),
      onRejectPressed: () => widget.onRejectPressed(itemIndex),
    );
  }

  OrderItemCard_OtherPeopleItem _buildOtherPeopleItem(int itemIndex) {
    var item = widget.order.items[itemIndex];
    return OrderItemCard_OtherPeopleItem(
      item: OrderItemCardProps_Item.fromOrderItem(
        item: item,
        usersMap: widget.ordersUsersMap,
      ),
      onSharePressed: () => widget.onSharePressed(itemIndex),
    );
  }

  OrderItemCard_InReceipt _buildMyItem(int itemIndex) {
    var item = widget.order.items[itemIndex];

    return OrderItemCard_InReceipt(
      item: OrderItemCardProps_Item.fromOrderItem(
        item: item,
        usersMap: widget.ordersUsersMap,
      ),
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
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Orders Yet!',
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
          //     backgroundColor: AppColors.primary,
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
