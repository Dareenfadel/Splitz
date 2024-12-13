import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/screens/wrapper.dart';

class CashPaymentScreen extends StatefulWidget {
  final Order order;

  const CashPaymentScreen({
    super.key,
    required this.order,
  });

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  final OrderService _orderService = OrderService();
  late final StreamSubscription<bool> _isPaidStreamSubscription;

  @override
  void initState() {
    super.initState();
    var currentUser = context.read<UserModel>();
    _isPaidStreamSubscription = _orderService
        .listenToUserPaymentStatus(
      orderId: widget.order.orderId,
      userId: currentUser.uid,
    )
        .listen((isPaid) {
      if (isPaid && mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Wrapper()), (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _isPaidStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Cash Payment'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _buildQR(),
                      const SizedBox(height: 32),
                      Icon(
                        Icons.person_pin_circle_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Visit the Cashier',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Show this QR code to complete your payment',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Container _buildQR() {
    var currentUser = context.watch<UserModel>();

    var qrData = jsonEncode({
      'orderId': widget.order.orderId,
      'userId': currentUser.uid,
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: QrImageView(
        data: qrData,
        size: 200,
        backgroundColor: Colors.white,
      ),
    );
  }
}
