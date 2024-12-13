import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__base.dart';

class SplitEquallyConfirmationScreen extends StatefulWidget {
  final Order order;
  final Map<String, UserModel> orderUsersMap;

  const SplitEquallyConfirmationScreen({
    super.key,
    required this.order,
    required this.orderUsersMap,
  });

  @override
  State<SplitEquallyConfirmationScreen> createState() =>
      _SplitEquallyConfirmationScreenState();
}

class _SplitEquallyConfirmationScreenState
    extends State<SplitEquallyConfirmationScreen> {
  final OrderService _orderService = OrderService();

  void _onAcceptPressed() async {
    var currentUser = context.read<UserModel>();
    context.loaderOverlay.show();
    await _orderService.acceptSplitAllEquallyRequest(
      orderId: widget.order.orderId,
      acceptingUserId: currentUser.uid,
    );
    if (mounted) context.loaderOverlay.hide();
  }

  void _onRejectPressed() async {
    var currentUser = context.read<UserModel>();
    context.loaderOverlay.show();
    await _orderService.rejectSplitAllEquallyRequest(
      orderId: widget.order.orderId,
      rejectingUserId: currentUser.uid,
    );
    if (mounted) context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Split Equally'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildItemsList(),
        _buildSharePriceCard(),
      ],
    );
  }

  Container _buildSharePriceCard() {
    var currentUser = context.watch<UserModel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Total Share',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${widget.order.splitEquallyPrice.toStringAsFixed(2)} EGP',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          widget.order.userAcceptedSplitEquallyRequest(currentUser.uid)
              ? _buildWaitingForOtherUsersMessage()
              : _buildAcceptRejectButtons(),
        ],
      ),
    );
  }

  Widget _buildWaitingForOtherUsersMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Waiting for other users to accept the split...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildAcceptRejectButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _onRejectPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _onAcceptPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }

  Expanded _buildItemsList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.order.nonOrderingItems.length,
        itemBuilder: (context, index) =>
            _buildItem(widget.order.nonOrderingItems[index]),
      ),
    );
  }

  Padding _buildItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: OrderItemCard_Base(
        item: item,
        orderUsersMap: widget.orderUsersMap,
        splitPrice: item.price / widget.order.nonPaidUserIds.length,
      ),
    );
  }
}
