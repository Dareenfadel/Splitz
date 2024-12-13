import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/services/order_service.dart';

class ScanBillQrScreen extends StatefulWidget {
  const ScanBillQrScreen({
    super.key,
  });

  @override
  ScanBillQrScreenState createState() => ScanBillQrScreenState();
}

class ScanBillQrScreenState extends State<ScanBillQrScreen> {
  final MobileScannerController controller = MobileScannerController();
  final OrderService orderService = OrderService();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Transparent background for the whole screen
      appBar: AppBar(
        backgroundColor: AppColors.primary, // App bar with color
        title: const Text(
          'Scan QR Code To View Bill',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        centerTitle: true, // Center the app bar title
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Set back button color to white
      ),
      body: Stack(
        children: [
          // Full screen camera view
          MobileScanner(
            controller: controller,
            onDetect: (barcodeCapture) {
              final String code =
                  barcodeCapture.barcodes.first.rawValue ?? '---';
              debugPrint('Scanned QR Code: $code');
              controller.stop(); // Stop the camera after scanning

              var jsonData = jsonDecode(code);

              Navigator.pushNamed(context, '/cashier', arguments: jsonData);
            },
          ),
          // Semi-transparent background overlay (outside the square)
          Container(
            color: Colors.black
                .withOpacity(0.5), // Semi-transparent black background
          ),
          // Centered square (full transparency in the middle)
          Center(
            child: Container(
              width: 280, // Size of the square
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Border color for the square
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Instructions at the bottom of the screen
        ],
      ),
    );
  }
}
