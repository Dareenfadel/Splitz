import 'package:flutter/material.dart';

class NavBarAdmin extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  NavBarAdmin({required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index != currentIndex) {
          onTabTapped(index);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 0
                ? Icons.list_alt_rounded
                : Icons.list_alt_outlined,
          ),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 1 ? Icons.history : Icons.history_outlined,
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 2
                ? Icons.restaurant_menu
                : Icons.restaurant_menu_outlined,
          ),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 3 ? Icons.person : Icons.person_outline,
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
