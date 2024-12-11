import 'package:flutter/material.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

import '../splitted_item_info_card/splitted_item_info_card.dart';
import '../splitted_users_list/splitted_users_list.dart';
import '../selectable_users_list/selectable_users_list.dart';

// ignore: camel_case_types
class ManageOrderItemLayout extends StatefulWidget {
  final OrderItem orderItem;
  final Map<String, UserModel> orderUsersMap;
  final Function(List<String> selectedUsers) onRequestPressed;
  final Function() onLeavePressed;

  const ManageOrderItemLayout({
    super.key,
    required this.orderItem,
    required this.onLeavePressed,
    required this.onRequestPressed,
    required this.orderUsersMap,
  });

  @override
  State<ManageOrderItemLayout> createState() => _ManageOrderItemLayoutState();
}

// ignore: camel_case_types
class _ManageOrderItemLayoutState extends State<ManageOrderItemLayout> {
  final Set<String> _selectedUsers = {};

  List<UserModel> get notSplittedWithUsers {
    return widget.orderUsersMap.values
        .where((user) => !widget.orderItem.isSharedWithUser(user.uid))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 48,
          bottom: 24,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPriceInfoCard(),
            _buildOrderItemUsersList(),
            _buildLeaveAndRequest()
          ],
        ),
      ),
    );
  }

  SplittedItemInfoCard _buildPriceInfoCard() {
    var totalPrice = widget.orderItem.price;
    var currentUsersCount = widget.orderItem.userList.length;
    var allUsersCount = currentUsersCount + _selectedUsers.length;

    return SplittedItemInfoCard(
      totalPrice: widget.orderItem.price,
      splitPrice: totalPrice / allUsersCount,
    );
  }

  Column _buildOrderItemUsersList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSplittedWithUsersList(),
        _buildRequestUsersList(),
      ],
    );
  }

  SplittedUsersList _buildSplittedWithUsersList() {
    return SplittedUsersList(
      users: widget.orderItem.userList,
      orderUsersMap: widget.orderUsersMap,
    );
  }

  SelectableUserList _buildRequestUsersList() {
    return SelectableUserList(
        users: notSplittedWithUsers,
        selectedUsersIds: _selectedUsers,
        onUserSelected: (user) {
          setState(() {
            _selectedUsers.add(user.uid);
          });
        },
        onUserDeselected: (user) {
          setState(() {
            _selectedUsers.remove(user.uid);
          });
        });
  }

  Widget _buildLeaveAndRequest() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onLeavePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Leave',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onRequestPressed(_selectedUsers.toList());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
