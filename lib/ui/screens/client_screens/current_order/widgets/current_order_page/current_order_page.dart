import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';

import 'current_order_page__all_items_tab.dart';
import 'current_order_page__my_items_tab.dart';
import 'current_order_page__requests_tab.dart';

class CurrentOrderPage extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;

  final Function(int itemIndex) onApprovePressed;
  final Function(int itemIndex) onRejectPressed;
  final Function(int itemIndex) onManagePressed;
  final Function(int itemIndex) onSharePressed;
  final Function() onProceedToPaymentPressed;

  const CurrentOrderPage({
    super.key,
    required this.order,
    required this.orderUsersMap,
    required this.onApprovePressed,
    required this.onRejectPressed,
    required this.onManagePressed,
    required this.onSharePressed,
    required this.onProceedToPaymentPressed,
  });

  @override
  State<CurrentOrderPage> createState() => _CurrentOrderPageState();
}

class _CurrentOrderPageState extends State<CurrentOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        color: AppColors.primary,
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
        CurrentOrderPage_RequestsTab(
          order: widget.order,
          orderUsersMap: widget.orderUsersMap,
          onApprovePressed: widget.onApprovePressed,
          onRejectPressed: widget.onRejectPressed,
        ),
        CurrentOrderPage_MyItemsTab(
          order: widget.order,
          orderUsersMap: widget.orderUsersMap,
          onManagePressed: widget.onManagePressed,
          onProceedToPaymentPressed: widget.onProceedToPaymentPressed,
        ),
        CurrentOrderPage_AllItemsTab(
          order: widget.order,
          ordersUsersMap: widget.orderUsersMap,
          onManagePressed: widget.onManagePressed,
          onSharePressed: widget.onSharePressed,
          onAcceptPressed: widget.onApprovePressed,
          onRejectPressed: widget.onRejectPressed,
        ),
      ],
    );
  }
}
