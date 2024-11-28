import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../custom_widgets/orders_list.dart';
import 'account_screen.dart';
import 'history_screen.dart';
import 'menu_screen.dart';

class AdminHomePage extends StatefulWidget {
  final String restaurantId;
  AdminHomePage({required this.restaurantId});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Widget> _screens = [
    HistoryScreen(),
    MenuScreen(),
    AccountScreen(),
  ];

  final List<String> orderStates = ['Pending', 'In Progress', 'Served'];

  final List<PreferredSizeWidget> _appBars = [
    AppBar(
      title: const Text('Orders History'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    AppBar(
      title: const Text('Menu'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    AppBar(
      title: const Text('Account Settings'),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _currentIndex == 0
          ? AppBar(
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
                      borderSide:
                          const BorderSide(width: 5.0, color: Colors.white),
                      insets: const EdgeInsets.symmetric(horizontal: 16.0),
                      borderRadius: BorderRadius.circular(5)),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            )
          : _appBars[_currentIndex - 1],
      body: _currentIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: orderStates.map((status) {
                return OrdersList(
                  orderStatus: status,
                  restaurantId: widget.restaurantId,
                );
              }).toList(),
            )
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0
                  ? Icons.list_alt_rounded
                  : Icons.list_alt_outlined,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 1 ? Icons.history : Icons.history_outlined,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2
                  ? Icons.restaurant_menu
                  : Icons.restaurant_menu_outlined,
            ),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 3 ? Icons.person : Icons.person_outline,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
