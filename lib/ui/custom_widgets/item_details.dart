import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ItemDetails extends StatelessWidget {
  final item;

  ItemDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: item['prepared'] ? AppColors.secondary : Colors.white,
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
          child: item['image_url'] != null && item['image_url'].isNotEmpty
              ? ClipOval(
                  child: Image.network(item['image_url'], fit: BoxFit.cover),
                )
              : const Icon(Icons.image_not_supported,
                  color: Colors.grey, size: 30),
        ),
        title: Text(
          item['item_name'],
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
              if (item['notes'] != null) Text('Notes: ${item['notes']}'),
              if (item['extras'] != null &&
                  item['extras'] is List &&
                  item['extras'].isNotEmpty)
                Wrap(
                  children: [
                    const Text("Extras: "),
                    ...item['extras'].asMap().entries.map<Widget>((entry) {
                      int index = entry.key;
                      var extra = entry.value;
                      bool isLast = index == item['extras'].length - 1;
                      return Text(
                        '${extra['name']} (x${extra['quantity'] ?? 1})${isLast ? '' : ' , '}',
                        style: const TextStyle(fontSize: 15),
                      );
                    }).toList(),
                  ],
                )
            ],
          ),
        ),
        trailing: Text(
          'x${item['quantity']}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
