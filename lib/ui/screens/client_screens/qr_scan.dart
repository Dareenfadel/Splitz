import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:splitz/ui/screens/client_screens/orders_page.dart';
import 'package:splitz/constants/app_colors.dart';

class QrCodeScanner extends StatefulWidget {
  QrCodeScanner({super.key});

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background for the whole screen
      appBar: AppBar(
        backgroundColor: AppColors.primary, // App bar with color
        title: Text(
          'Scan QR Code To Join Table',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor),
        ),
        centerTitle: true, // Center the app bar title
        iconTheme: IconThemeData(color: Colors.white), // Set back button color to white
      ),
      body: Stack(
        children: [
          // Full screen camera view
          MobileScanner(
            controller: controller,
            onDetect: (barcodeCapture) {
              final String code = barcodeCapture.barcodes.first.rawValue ?? '---';
              debugPrint('Scanned QR Code: $code');
              controller.stop(); // Stop the camera after scanning
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage()),
              );
            },
          ),
          // Semi-transparent background overlay (outside the square)
          Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent black background
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
