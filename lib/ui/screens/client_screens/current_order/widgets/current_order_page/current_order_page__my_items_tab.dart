import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import '../order_item_card/order_item_card__in_receipt.dart';
import '../order_item_card/order_item_card_props.dart';

// ignore: camel_case_types
class CurrentOrderPage_MyItemsTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;
  final Function(int itemIndex) onManagePressed;
  final Function() onProceedToPaymentPressed;

  const CurrentOrderPage_MyItemsTab({
    super.key,
    required this.onManagePressed,
    required this.onProceedToPaymentPressed,
    required this.order,
    required this.orderUsersMap,
  });

  @override
  State<CurrentOrderPage_MyItemsTab> createState() =>
      _CurrentOrderPage_MyItemsTabState();
}

// ignore: camel_case_types
class _CurrentOrderPage_MyItemsTabState
    extends State<CurrentOrderPage_MyItemsTab> {
  late List<OrderItem> items;

  @override
  void initState() {
    super.initState();
    var currentUser = context.read<UserModel>();
    items = widget.order.acceptedItemsForUserId(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return (items.isEmpty ? _buildNoItems() : _buildItemsList());
  }

  Widget _buildItemsList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) => _buildItem(index),
          ),
        ),
        _buildTotalPriceContainer()
      ],
    );
  }

  Container _buildTotalPriceContainer() {
    var currentUser = context.watch<UserModel>();

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
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 24.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${widget.order.totalBillForUserId(currentUser.uid)} EGP',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onProceedToPaymentPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Proceed to payment',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(int itemIndex) {
    var item = items[itemIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: OrderItemCard_InReceipt(
        item: OrderItemCardProps_Item.fromOrderItem(
          item: item,
          usersMap: widget.orderUsersMap,
        ),
        onManagePressed: () => widget.onManagePressed(itemIndex),
      ),
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
              Icons.shopping_cart,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Items Added Yet!',
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
              'Your items will appear here once you add them to your order.',
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
