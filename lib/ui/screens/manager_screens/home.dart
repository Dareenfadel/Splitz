import 'package:flutter/material.dart';
import 'package:splitz/ui/custom_widgets/nav_bar_admin.dart';
import '../../../constants/app_colors.dart';
import 'account_screen.dart';
import 'history_screen.dart';
// import 'in_progress_orders_screen.dart';
import 'menu_screens/menu_screen.dart';
import 'orders_screen.dart';
// import 'pending_orders_screen.dart';
// import 'serverd_orders_screen.dart';

class AdminHomePage extends StatefulWidget {
  final String restaurantId;

  AdminHomePage({required this.restaurantId});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late int _currentIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      OrdersScreen(restaurantId: widget.restaurantId),
      HistoryScreen(restaurantId: widget.restaurantId),
      MenuScreen(),
      AccountScreen(),
    ];
    _currentIndex = 0;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavBarAdmin(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
