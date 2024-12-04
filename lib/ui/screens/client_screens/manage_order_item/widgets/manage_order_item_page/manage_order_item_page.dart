import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/screens/client_screens/manage_order_item/widgets/selectable_users_list/selectable_users_list_props.dart';

import '../splitted_item_info_card/splitted_item_info_card.dart';
import '../splitted_users_list/splitted_users_list.dart';
import '../selectable_users_list/selectable_users_list.dart';

// ignore: camel_case_types
class ManageOrderItemPage extends StatefulWidget {
  final OrderItem orderItem;
  final Map<String, UserModel> orderUsersMap;
  final Function(List<String> selectedUsers) onRequestPressed;
  final Function() onLeavePressed;

  const ManageOrderItemPage({
    super.key,
    required this.orderItem,
    required this.onLeavePressed,
    required this.onRequestPressed,
    required this.orderUsersMap,
  });

  @override
  State<ManageOrderItemPage> createState() => _ManageOrderItemPageState();
}

// ignore: camel_case_types
class _ManageOrderItemPageState extends State<ManageOrderItemPage> {
  final Set<String> _selectedUsers = {};

  List<UserModel> get notSplittedWithUsers {
    return widget.orderUsersMap.values
        .where((user) => !widget.orderItem.isSharedWithUser(user.uid))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        users: widget.orderItem.userList
            .map((user) => SplittedUsersListProps_User.fromOrderItemUser(
                  user: user,
                  orderUsersMap: widget.orderUsersMap,
                ))
            .toList());
  }

  SelectableUserList _buildRequestUsersList() {
    return SelectableUserList(
        users: notSplittedWithUsers
            .map((user) => SelectableUsersListProps_User.fromUserModel(user))
            .toList(),
        selectedUsersIds: _selectedUsers,
        onUserSelected: (user) {
          setState(() {
            _selectedUsers.add(user.id);
          });
        },
        onUserDeselected: (user) {
          setState(() {
            _selectedUsers.remove(user.id);
          });
        });
  }

  Widget _buildLeaveAndRequest() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
              backgroundColor: AppColors.primary,
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
