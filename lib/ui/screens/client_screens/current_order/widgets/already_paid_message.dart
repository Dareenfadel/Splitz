import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/default_stream_builder.dart';
import 'package:splitz/ui/screens/client_screens/current_order/widgets/order_item_card/order_item_card__base.dart';

class AlreadyPaidMessage extends StatefulWidget {
  final String orderId;

  const AlreadyPaidMessage({
    super.key,
    required this.orderId,
  });

  @override
  State<AlreadyPaidMessage> createState() => _AlreadyPaidMessageState();
}

class _AlreadyPaidMessageState extends State<AlreadyPaidMessage> {
  final OrderService _orderService = OrderService();
  late final Stream<(Order, Map<String, UserModel>)> _orderStream;

  @override
  void initState() {
    super.initState();
    context.loaderOverlay.show();
    _orderStream = _orderService
        .listenToOrderAndItsUsersByOrderId(widget.orderId)
        .map((data) {
      if (mounted) context.loaderOverlay.hide();
      return data;
    });
  }

  Future<void> _onDonePressed() async {
    var currentUser = context.read<UserModel>();
    await _orderService.unsetCurrentOrderForUserId(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = context.watch<UserModel>();

    return DefaultStreamBuilder(
        stream: _orderStream,
        builder: (data) {
          var (order, orderUsersMap) = data;
          var userItems = order.acceptedItemsForUserId(currentUser.uid);

          return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.width * 0.09,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.04),
                        Text(
                          'You have already paid for this order.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
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
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: _onDonePressed,
                  child: const Text('Leave Order'),
                ),
              ));
        });
  }
}
