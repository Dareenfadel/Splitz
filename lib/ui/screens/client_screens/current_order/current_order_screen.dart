import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_item_service.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';
import 'widgets/current_order_page/current_order_page.dart';
import '../manage_order_item/manage_order_item_screen.dart';

class CurrentOrderScreen extends StatefulWidget {
  final String orderId;

  const CurrentOrderScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  final OrderService _orderService = OrderService();
  final OrderItemService _orderItemService = OrderItemService();

  late final Stream<(Order, Map<String, UserModel>)> _stream;
  late final UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _stream = _orderService.listenToOrderAndItsUsersByOrderId(widget.orderId);
    _currentUser = context.read<UserModel>();
  }

  onProceedToPaymentPressed() {}

  onSharePressed(int itemIndex) {
    _orderItemService.addUserToOrderItem(
      orderId: widget.orderId,
      itemIndex: itemIndex,
      userId: _currentUser.uid,
    );
  }

  onRejectPressed(int itemIndex) {
    _orderItemService.rejectOrderItemByUserId(
      orderId: widget.orderId,
      itemIndex: itemIndex,
      userId: _currentUser.uid,
    );
  }

  onApprovePressed(int itemIndex) {
    _orderItemService.acceptOrderItemByUserId(
      orderId: widget.orderId,
      itemIndex: itemIndex,
      userId: _currentUser.uid,
    );
  }

  onManagePressed(int itemIndex) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ManageOrderItemScreen(
            itemIndex: itemIndex, orderId: widget.orderId)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultStreamBuilder(
      stream: _stream,
      builder: (data) {
        var (order, orderUsersMap) = data;

        return CurrentOrderPage(
          order: order,
          orderUsersMap: orderUsersMap,
          onApprovePressed: onApprovePressed,
          onRejectPressed: onRejectPressed,
          onManagePressed: onManagePressed,
          onSharePressed: onSharePressed,
          onProceedToPaymentPressed: onProceedToPaymentPressed,
        );
      },
    );
  }
}
