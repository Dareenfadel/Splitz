import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_item_service.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';
import 'package:splitz/ui/screens/client_screens/current_order/split_equally_screen.dart';
import 'package:splitz/ui/screens/client_screens/payment/choose_payment_method_screen.dart';
import 'widgets/current_order_layout/current_order_layout.dart';
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
    _stream = _orderService
        .listenToOrderAndItsUsersByOrderId(widget.orderId)
        .map((data) {
      if (mounted) context.loaderOverlay.hide();
      return data;
    });

    _currentUser = context.read<UserModel>();
  }

  _onProceedToPaymentPressed(Order order) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChoosePaymentMethodScreen(
              order: order,
            )));
  }

  _onSharePressed(int itemIndex) async {
    context.loaderOverlay.show();
    await _orderItemService.addUserToOrderItem(
      orderId: widget.orderId,
      itemIndex: itemIndex,
      userId: _currentUser.uid,
    );
  }

  _onRejectPressed(int itemIndex) async {
    context.loaderOverlay.show();
    await _orderItemService.rejectOrderItemByUserId(
      orderId: widget.orderId,
      itemIndex: itemIndex,
      userId: _currentUser.uid,
    );
  }

  _onApprovePressed(int itemIndex) async {
    context.loaderOverlay.show();
    await _orderItemService.acceptOrderItemByUserId(
      orderId: widget.orderId,
      itemIndex: itemIndex,
      userId: _currentUser.uid,
    );
  }

  _onManagePressed(int itemIndex) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ManageOrderItemScreen(
              itemIndex: itemIndex,
              orderId: widget.orderId,
            )));
  }

  _onSplitEquallyPressed(Order order) async {
    var requestorUserId = _currentUser.uid;
    context.loaderOverlay.show();
    await _orderService.sendSplitAllEquallyRequest(
      orderId: order.orderId,
      requestorUserId: requestorUserId,
    );
    if (mounted) context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultStreamBuilder(
      stream: _stream,
      builder: (data) {
        var (order, orderUsersMap) = data;

        if (order.splitEquallyPendingUserIds.isNotEmpty) {
          return SplitEquallyConfirmationScreen(
            order: order,
            orderUsersMap: orderUsersMap,
          );
        }

        return CurrentOrderLayout(
          order: order,
          orderUsersMap: orderUsersMap,
          onApprovePressed: _onApprovePressed,
          onRejectPressed: _onRejectPressed,
          onManagePressed: _onManagePressed,
          onSharePressed: _onSharePressed,
          onProceedToPaymentPressed: () => _onProceedToPaymentPressed(order),
          onSplitEquallyPressed: () => _onSplitEquallyPressed(order),
        );
      },
    );
  }
}
