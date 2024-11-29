import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/ui/custom_widgets/item_preview.dart';
import 'order_details.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String orderId;
  final Function(String) updateStatus;
  OrderCard(
      {required this.orderData,
      required this.orderId,
      required this.updateStatus});

  @override
  Widget build(BuildContext context) {
    final tableNumber = orderData['table_number'];
    final items = orderData['items'] as List<dynamic>;
    final orderStatus = orderData['status'];
    final firstTwoItems = items.take(2).toList();

    String getOrderStatusText(String status) {
      switch (status) {
        case "pending":
          return "Start order";
        case "in progress":
          return "Mark as served";
        case "served":
          return "Mark as paid";
        default:
          return "Unknown status";
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: const EdgeInsets.only(top: 50, left: 26, right: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
                color: AppColors.secondary,
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ...firstTwoItems.map((item) => ItemPreview(itemData: item)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FadeTransition(
                              opacity: animation,
                              child: OrderDetailsPage(
                                orderData: orderData,
                                orderId: orderId,
                                updateStatus: (newStatus) =>
                                    updateStatus(newStatus),
                              ),
                            ),
                          ));
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                          size: 20,
                        ),
                        label: const Text(
                          "View all",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          updateStatus(orderStatus == "pending"
                              ? "in progress"
                              : orderStatus == "in progress"
                                  ? "served"
                                  : "paid");
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(getOrderStatusText(orderStatus),
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 16,
          right: 16,
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: AppColors.secondary,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 12.0),
                  child: Column(
                    children: [
                      const Text(
                        "TABLE",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$tableNumber',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
