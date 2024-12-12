import 'package:flutter/material.dart';

// TODO: Use theme colors instead of hard coded colors
import 'package:splitz/constants/app_colors.dart';

class SplittedItemInfoCard extends StatelessWidget {
  final double totalPrice;
  final double splitPrice;

  const SplittedItemInfoCard({
    super.key,
    required this.totalPrice,
    required this.splitPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${totalPrice.toStringAsFixed(2)} EGP',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey[300],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Your Share',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${splitPrice.toStringAsFixed(2)} EGP',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
