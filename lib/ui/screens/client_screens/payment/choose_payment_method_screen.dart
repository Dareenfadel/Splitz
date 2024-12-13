import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/payment_service.dart';
import 'package:splitz/ui/screens/client_screens/payment/cash_payment_screen.dart';
import 'package:splitz/ui/screens/wrapper.dart';

const String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantName": "Splitz"
    },
    "transactionInfo": {
      "countryCode": "EG",
      "currencyCode": "EGP"
    }
  }
}''';

var pay = Pay({
  PayProvider.google_pay: PaymentConfiguration.fromJsonString(defaultGooglePay),
});

class ChoosePaymentMethodScreen extends StatefulWidget {
  final Order order;

  const ChoosePaymentMethodScreen({
    super.key,
    required this.order,
  });

  @override
  State<ChoosePaymentMethodScreen> createState() =>
      _ChoosePaymentMethodScreenState();
}

class _ChoosePaymentMethodScreenState extends State<ChoosePaymentMethodScreen> {
  final PaymentService _paymentService = PaymentService();

  _onPaymentResult(Map<String, dynamic> response) async {
    var currentUser = context.read<UserModel>();

    context.loaderOverlay.show();
    await _paymentService.markUserAsPaid(
      orderId: widget.order.orderId,
      userId: currentUser.uid,
    );
    if (mounted) context.loaderOverlay.hide();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Wrapper()),
      (route) => false,
    );
  }

  _onPayWithCard() async {
    var currentUser = context.read<UserModel>();
    var bill = widget.order.totalBillForUserId(currentUser.uid);

    var result = await pay.showPaymentSelector(
      PayProvider.google_pay,
      [
        PaymentItem(
          label: 'Total',
          amount: bill.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        )
      ],
    );
    _onPaymentResult(result);
  }

  _onPayCash() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CashPaymentScreen(
          order: widget.order,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPaymentMethodCard(
              context,
              icon: Icons.credit_card,
              title: 'Credit Card',
              onPressed: _onPayWithCard,
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodCard(
              context,
              icon: Icons.money,
              title: 'Cash',
              onPressed: _onPayCash,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(),
            const Icon(Icons.arrow_forward_sharp),
          ],
        ),
      ),
    );
  }
}
