import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_item_service.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';

import 'widgets/manage_order_item_page/manage_order_item_page.dart';

class ManageOrderItemScreen extends StatefulWidget {
  final String orderId;
  final int itemIndex;

  const ManageOrderItemScreen({
    super.key,
    required this.itemIndex,
    required this.orderId,
  });

  @override
  State<ManageOrderItemScreen> createState() => _ManageOrderItemScreenState();
}

class _ManageOrderItemScreenState extends State<ManageOrderItemScreen> {
  final OrderItemService _orderItemService = OrderItemService();
  late final Stream<(OrderItem, Map<String, UserModel>)> _stream;
  late final UserModel _currentUser;

  @override
  initState() {
    super.initState();
    _stream = _orderItemService.listenToOrderItemAndItsUsers(
      orderId: widget.orderId,
      itemIndex: widget.itemIndex,
    );
    _currentUser = context.read<UserModel>();
  }

  _onLeavePressed() {
    _orderItemService.removeUserFromOrderItem(
      orderId: widget.orderId,
      itemIndex: widget.itemIndex,
      userId: _currentUser.uid,
    );
  }

  _onRequestPressed(List<String> selectedUsersIds) {
    for (var userId in selectedUsersIds) {
      _orderItemService.addUserToOrderItem(
        orderId: widget.orderId,
        itemIndex: widget.itemIndex,
        userId: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultStreamBuilder(
      stream: _stream,
      builder: (data) {
        var (orderItem, orderUsersMap) = data;
        return ManageOrderItemPage(
          orderItem: orderItem,
          orderUsersMap: orderUsersMap,
          onRequestPressed: _onRequestPressed,
          onLeavePressed: _onLeavePressed,
        );
      },
    );
  }
}
