import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_item_service.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';

import 'widgets/manage_order_item_layout/manage_order_item_layout.dart';

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

  late final UserModel _currentUser;
  late final Stream<(OrderItem, Map<String, UserModel>)> _stream;

  @override
  void initState() {
    super.initState();
    _currentUser = context.read<UserModel>();
    _stream = _orderItemService
        .listenToOrderItemAndItsUsers(
      orderId: widget.orderId,
      itemIndex: widget.itemIndex,
    )
        .map((data) {
      if (mounted) context.loaderOverlay.hide();
      return data;
    });
  }

  _onLeavePressed() async {
    context.loaderOverlay.show();
    await _orderItemService.removeUserFromOrderItem(
      orderId: widget.orderId,
      itemIndex: widget.itemIndex,
      userId: _currentUser.uid,
    );
    if (mounted) Navigator.pop(context);
  }

  _onRequestPressed(List<String> selectedUsersIds) async {
    context.loaderOverlay.show();
    for (var userId in selectedUsersIds) {
      await _orderItemService.sendRequestToOrderItem(
        orderId: widget.orderId,
        itemIndex: widget.itemIndex,
        requestedByUserId: _currentUser.uid,
        requestedToUserId: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultStreamBuilder(
      stream: _stream,
      builder: (data) {
        var (orderItem, orderUsersMap) = data;

        return ManageOrderItemLayout(
          orderItem: orderItem,
          orderUsersMap: orderUsersMap,
          onRequestPressed: _onRequestPressed,
          onLeavePressed: _onLeavePressed,
        );
      },
    );
  }
}
