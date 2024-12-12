import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';

import 'current_order_layout__all_items_tab.dart';
import 'current_order_layout__my_items_tab.dart';
import 'current_order_layout__requests_tab.dart';

class CurrentOrderLayout extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;

  final Function(int itemIndex) onApprovePressed;
  final Function(int itemIndex) onRejectPressed;
  final Function(int itemIndex) onManagePressed;
  final Function(int itemIndex) onSharePressed;
  final Function() onProceedToPaymentPressed;
  final Function() onSplitEquallyPressed;

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
  });

  @override
  State<CurrentOrderLayout> createState() => _CurrentOrderLayoutState();
}

class _CurrentOrderLayoutState extends State<CurrentOrderLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                controller: _tabController,
                tabs: [
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
      controller: _tabController,
      children: [
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
