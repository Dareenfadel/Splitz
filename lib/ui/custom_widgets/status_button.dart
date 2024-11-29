import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class StatusButton extends StatelessWidget {
  final String orderStatus;
  final Function(String) updateStatus;

  StatusButton({required this.orderStatus, required this.updateStatus});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        width: 180,
        child: FloatingActionButton(
          onPressed: () => {
            updateStatus(orderStatus == "pending"
                ? "in progress"
                : orderStatus == "in progress"
                    ? "served"
                    : "paid"),
            Navigator.pop(context)
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 3,
          child: Text(
            getOrderStatusText(orderStatus),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
