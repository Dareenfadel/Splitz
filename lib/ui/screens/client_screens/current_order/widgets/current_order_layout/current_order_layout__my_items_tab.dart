import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import '../order_item_card/order_item_card__in_receipt.dart';

// ignore: camel_case_types
class CurrentOrderLayout_MyItemsTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;
  final Function(int itemIndex) onManagePressed;
  final Function() onProceedToPaymentPressed;

  const CurrentOrderLayout_MyItemsTab({
    super.key,
    required this.onManagePressed,
    required this.onProceedToPaymentPressed,
    required this.order,
    required this.orderUsersMap,
  });

  @override
  State<CurrentOrderLayout_MyItemsTab> createState() =>
      _CurrentOrderLayout_MyItemsTabState();
}

// ignore: camel_case_types
class _CurrentOrderLayout_MyItemsTabState
    extends State<CurrentOrderLayout_MyItemsTab> {
  late UserModel currentUser;
  late List<OrderItem> myItems;

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<UserModel>();
    myItems = widget.order.acceptedItemsForUserId(currentUser.uid);

    return (myItems.isEmpty ? _buildNoItems() : _buildItemsList());
  }

  Widget _buildItemsList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: myItems.length,
            itemBuilder: (context, index) => _buildItem(myItems[index]),
          ),
        ),
        _buildTotalPriceContainer()
      ],
    );
  }

  Container _buildTotalPriceContainer() {
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${widget.order.totalBillForUserId(currentUser.uid).toStringAsFixed(2)} EGP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
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
                backgroundColor: Theme.of(context).colorScheme.primary,
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

  Widget _buildItem(OrderItem item) {
    var itemIndex = widget.order.items.indexOf(item);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: OrderItemCard_InReceipt(
        item: item,
        ordersUsersMap: widget.orderUsersMap,
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Items Added Yet!',
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
