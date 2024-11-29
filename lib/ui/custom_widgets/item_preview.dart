import 'package:flutter/material.dart';

class ItemPreview extends StatelessWidget {
  final Map<String, dynamic> itemData;

  ItemPreview({required this.itemData});

  @override
  Widget build(BuildContext context) {
    final itemName = itemData['item_name'];
    final itemNotes = itemData['notes'];
    final itemQuantity = itemData['quantity'];
    final itemImage = itemData['image_url'];

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
            child: itemImage != null && itemImage.isNotEmpty
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
        itemNotes ?? 'No notes',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
