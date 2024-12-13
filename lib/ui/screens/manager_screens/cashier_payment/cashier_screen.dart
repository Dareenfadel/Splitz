import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/data/services/payment_service.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__base.dart';
import 'package:splitz/ui/screens/client_screens/payment/choose_payment_method_screen.dart';

class CashierScreen extends StatefulWidget {
  final String userId;
  final String orderId;

  const CashierScreen({
    super.key,
    required this.userId,
    required this.orderId,
  });

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final OrderService _orderService = OrderService();
  final PaymentService _paymentService = PaymentService();

  late final Stream<(Order, Map<String, UserModel>)> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _orderService.listenToOrderAndItsUsersByOrderId(widget.orderId);
  }

  _onMarkAsPaidPressed() async {
    context.loaderOverlay.show();
    await _paymentService.markUserAsPaid(
      orderId: widget.orderId,
      userId: widget.userId,
    );
    if (mounted) {
      context.loaderOverlay.hide();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultStreamBuilder(
      stream: _stream,
      builder: (data) {
        var (order, orderUsersMap) = data;
        var userItems = order.acceptedItemsForUserId(widget.userId);
        var totalBillForUser = order.totalBillForUserId(widget.userId);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Payment Collection'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order Items List
                Expanded(
                  child: ListView.builder(
                    itemCount: userItems.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrderItemCard_Base(
                        item: userItems[index],
                        orderUsersMap: orderUsersMap,
                      ),
                    ),
                  ),
                ),

                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Amount',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${totalBillForUser.toStringAsFixed(2)} EGP',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Mark as Paid Button
                ElevatedButton(
                  onPressed: _onMarkAsPaidPressed,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Mark as Paid'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
