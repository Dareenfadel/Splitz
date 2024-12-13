import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../custom_widgets/orders_list.dart';

class OrdersScreen extends StatefulWidget {
  final String restaurantId;
  OrdersScreen({required this.restaurantId});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> orderStates = ['Pending', 'In Progress', 'Served'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: TabBar(
            controller: _tabController,
            tabs: orderStates.map((state) => Tab(text: state)).toList(),
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
            unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.textColor),
            indicatorColor: Colors.white,
            indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(width: 5.0, color: Colors.white),
                insets: const EdgeInsets.symmetric(horizontal: 16.0),
                borderRadius: BorderRadius.circular(5)),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: orderStates.map((status) {
          return OrdersList(
            orderStatus: status,
            restaurantId: widget.restaurantId,
          );
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/scan-bill');
        },
        icon: const Icon(Icons.qr_code),
        label: const Text('Scan Bill'),
      ),
    );
  }
}
