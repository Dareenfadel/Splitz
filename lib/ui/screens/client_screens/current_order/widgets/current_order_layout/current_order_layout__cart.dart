import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/custom_widgets/message_container.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__with_button.dart';

// ignore: camel_case_types
class CurrentOrderLayout_CartTab extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;
  final Function(int itemIndex) onRemoveCartItemPressed;
  final Function() onCheckoutCartPressed;
  final Function(int itemIndex) onEditCartItemPressed;
  final Function(int itemIndex) onDuplicateCartItemPressed;

  const CurrentOrderLayout_CartTab({
    super.key,
    required this.order,
    required this.orderUsersMap,
    required this.onCheckoutCartPressed,
    required this.onRemoveCartItemPressed,
    required this.onEditCartItemPressed,
    required this.onDuplicateCartItemPressed,
  });

  @override
  State<CurrentOrderLayout_CartTab> createState() =>
      _CurrentOrderLayout_CartTabState();
}

// ignore: camel_case_types
class _CurrentOrderLayout_CartTabState
    extends State<CurrentOrderLayout_CartTab> {
  late UserModel currentUser;
  late List<OrderItem> myItems;

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<UserModel>();
    myItems = widget.order.cartItemsForUserId(currentUser.uid);

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
                  '${widget.order.cartTotalForUserId(currentUser.uid).toStringAsFixed(2)} EGP',
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
              onPressed: widget.onCheckoutCartPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Add All To Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
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
      child: OrderItemCard_WithButtons(
        item: item,
        ordersUsersMap: widget.orderUsersMap,
        buttons: [
          OrderItemCard_Props_Button(
            onButtonPressed: () => widget.onEditCartItemPressed(itemIndex),
            icon: Icons.edit,
            color: AppColors.primary.withOpacity(0.2),
          ),
          OrderItemCard_Props_Button(
            onButtonPressed: () => widget.onDuplicateCartItemPressed(itemIndex),
            icon: Icons.add_outlined,
            color: AppColors.primary.withOpacity(0.5),
          ),
          OrderItemCard_Props_Button(
            onButtonPressed: () => widget.onRemoveCartItemPressed(itemIndex),
            icon: Icons.delete,
            color: AppColors.primary.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildNoItems() {
    return const MessageContainer(
      icon: Icons.shopping_cart,
      message: "No Items Added Yet!",
      subMessage: 'Your items will appear here once you add them in your cart.',
    );
  }
}
