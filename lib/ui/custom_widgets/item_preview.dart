import 'package:flutter/material.dart';
import 'package:splitz/data/models/order_item.dart';

class ItemPreview extends StatelessWidget {
  final OrderItem item;

  ItemPreview({required this.item});

  @override
  Widget build(BuildContext context) {
    final itemName = item.itemName;
    final itemNotes = item.notes;
    final itemQuantity = item.quantity;
    final itemImage = item.imageUrl;

    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 10),
          Text('x$itemQuantity',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 32),
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: itemImage.isNotEmpty
                ? ClipOval(
                    child: Image.network(itemImage, fit: BoxFit.cover),
                  )
                : const Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 30),
          ),
          const SizedBox(width: 22),
        ],
      ),
      title: Text(
        itemName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        itemNotes.isNotEmpty ? itemNotes : 'No notes',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
