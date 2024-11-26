import 'package:flutter/material.dart';

import 'package:splitz/data/services/auth.dart';

import '../../../constants/app_colors.dart';
import 'account_screen.dart';
import 'history_screen.dart';
import 'in_progress_orders_screen.dart';
import 'menu_screen.dart';
import 'orders_screen.dart';
import 'pending_orders_screen.dart';
import 'serverd_orders_screen.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Widget> _screens = [
    OrdersScreen(),
    HistoryScreen(),
    MenuScreen(),
    AccountScreen(),
  ];

  final List<PreferredSizeWidget> _appBars = [
    AppBar(
      title: const Text('Orders History'),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    AppBar(
      title: const Text('Menu'),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    AppBar(
      title: const Text('Account Settings'),
      centerTitle: true,
      titleTextStyle: TextStyle(
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
      appBar: _currentIndex == 0
          ? AppBar(
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'In Progress'),
                    Tab(text: 'Served'),
                  ],
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textColor),
                  indicatorColor: Colors.white,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5.0, color: Colors.white),
                      insets: EdgeInsets.symmetric(horizontal: 16.0),
                      borderRadius: BorderRadius.circular(5)),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            )
          : _appBars[_currentIndex - 1],
      body: _currentIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: [
                PendingOrdersScreen(),
                InProgressOrdersScreen(),
                ServedOrdersScreen(),
              ],
            )
          : _screens[_currentIndex - 1],
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

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthService _auth = AuthService();
//     return Scaffold(
//       backgroundColor: Colors.brown[50],
//       appBar: AppBar(
//         title: Text('Homee ya manager'),
//         backgroundColor: Colors.brown[400],
//         elevation: 0.0,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () async {
//               await _auth.signOut();
//             },
//             icon: Icon(Icons.person),
//             tooltip: 'log out',
//           )
//         ],
//       ),
//     );
//   }
// }
