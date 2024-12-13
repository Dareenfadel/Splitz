import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/current_order_layout/current_order_layout__cart.dart';

import 'current_order_layout__all_items_tab.dart';
import 'current_order_layout__my_items_tab.dart';
import 'current_order_layout__requests_tab.dart';

class CurrentOrderLayoutTab {
  static const cart = 0;
  static const requests = 1;
  static const myItems = 2;
  static const allItems = 3;
}

class CurrentOrderLayout extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;

  final Function(int itemIndex) onApprovePressed;
  final Function(int itemIndex) onRejectPressed;
  final Function(int itemIndex) onManagePressed;
  final Function(int itemIndex) onSharePressed;
  final Function(int itemIndex) onRemoveCartItemPressed;
  final Function() onProceedToPaymentPressed;
  final Function() onSplitEquallyPressed;
  final Function() onCheckoutCartPressed;
  final Function(int itemIndex) onEditCartItemPressed;
  final Function(int itemIndex) onDuplicateCartItemPressed;
  final TabController tabController;

  const CurrentOrderLayout({
    super.key,
    required this.order,
    required this.orderUsersMap,
    required this.onApprovePressed,
    required this.onRejectPressed,
    required this.onManagePressed,
    required this.onSharePressed,
    required this.onProceedToPaymentPressed,
    required this.onSplitEquallyPressed,
    required this.onCheckoutCartPressed,
    required this.onRemoveCartItemPressed,
    required this.onEditCartItemPressed,
    required this.onDuplicateCartItemPressed,
    required this.tabController,
  });

  @override
  State<CurrentOrderLayout> createState() => _CurrentOrderLayoutState();
}

class _CurrentOrderLayoutState extends State<CurrentOrderLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildTabBar(),
      body: _buildTabBarView(),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              TabBar(
                tabAlignment: TabAlignment.center,
                labelColor: Colors.white,
                labelPadding: const EdgeInsets.all(15),
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                controller: widget.tabController,
                tabs: [
                  "Cart",
                  "Requests",
                  "My Items",
                  "All Items",
                ].map((e) {
                  return Text(
                    e,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: widget.tabController,
      children: [
        CurrentOrderLayout_CartTab(
          order: widget.order,
          orderUsersMap: widget.orderUsersMap,
          onCheckoutCartPressed: widget.onCheckoutCartPressed,
          onRemoveCartItemPressed: widget.onRemoveCartItemPressed,
          onEditCartItemPressed: widget.onEditCartItemPressed,
          onDuplicateCartItemPressed: widget.onDuplicateCartItemPressed,
        ),
        CurrentOrderLayout_RequestsTab(
          order: widget.order,
          orderUsersMap: widget.orderUsersMap,
          onApprovePressed: widget.onApprovePressed,
          onRejectPressed: widget.onRejectPressed,
        ),
        CurrentOrderLayout_MyItemsTab(
          order: widget.order,
          orderUsersMap: widget.orderUsersMap,
          onManagePressed: widget.onManagePressed,
          onProceedToPaymentPressed: widget.onProceedToPaymentPressed,
        ),
        CurrentOrderLayout_AllItemsTab(
          order: widget.order,
          ordersUsersMap: widget.orderUsersMap,
          onManagePressed: widget.onManagePressed,
          onSharePressed: widget.onSharePressed,
          onAcceptPressed: widget.onApprovePressed,
          onRejectPressed: widget.onRejectPressed,
          onSplitEquallyPressed: widget.onSplitEquallyPressed,
        ),
      ],
    );
  }
}
