import 'package:flutter/material.dart';
import 'package:splitz/data/models/order_item.dart';
import '../../constants/app_colors.dart';

class ItemDetails extends StatelessWidget {
  final OrderItem item;

  ItemDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: item.status == "in progress"
          ? Colors.blue.shade50
          : item.status == "served"
              ? AppColors.secondary
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.secondary,
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: item.imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                )
              : const Icon(Icons.image_not_supported,
                  color: Colors.grey, size: 30),
        ),
        title: Text(
          item.itemName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 73, 72, 72),
            fontWeight: FontWeight.normal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.notes.isNotEmpty ? item.notes : 'No notes'),
              if (item.extras.isNotEmpty)
                Wrap(
                  children: [
                    const Text("Extras: "),
                    ...item.extras.entries.toList().map((extra) {
                      String key = extra.key;
                      bool isLast = key == item.extras.keys.last;
                      return Text(
                        '${extra.key} (x${extra.value})${isLast ? '' : ' , '}',
                        style: const TextStyle(fontSize: 15),
                      );
                    })
                  ],
                ),
            ],
          ),
        ),
        trailing: Text(
          'x${item.quantity}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
