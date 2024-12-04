import 'package:flutter/material.dart';

import 'splitted_item_info_card.dart';

// ignore: camel_case_types
class SplittedItemInfoCard_Demo extends StatelessWidget {
  const SplittedItemInfoCard_Demo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SplittedItemInfoCard(
                totalPrice: 150.50,
                splitPrice: 75.25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
