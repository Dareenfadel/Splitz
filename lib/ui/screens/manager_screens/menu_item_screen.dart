import 'package:flutter/material.dart';
import 'package:splitz/data/models/menu_item.dart';

class MenuItemScreen extends StatelessWidget {
  final MenuItemModel menuItem;

  MenuItemScreen({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  menuItem.image,
                  height: 150,
                  width: 150,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.pink),
                    onPressed: () {
                      // Decrease quantity logic
                    },
                  ),
                  Text(
                    '2', // Replace with actual quantity state
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.pink),
                    onPressed: () {
                      // Increase quantity logic
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                menuItem.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${menuItem.price.toStringAsFixed(2)} EGP',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  SizedBox(width: 4),
                  Text(menuItem.overallRating.toString()),
                  SizedBox(width: 16),
                  Icon(Icons.local_fire_department,
                      color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Text('${menuItem.calories} cal'),
                  SizedBox(width: 16),
                  Icon(Icons.timer, color: Colors.blue, size: 18),
                  SizedBox(width: 4),
                  Text('${menuItem.preparationTime} min'),
                ],
              ),
              SizedBox(height: 16),
              Text(
                menuItem.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Toppings for you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8,
                children: menuItem.requiredOptions.first.choices
                    .map((choice) => ChoiceChip(
                          label: Text(choice.name),
                          selected: false, // Add selection state
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Add to order logic
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add to order',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${menuItem.price * 2} EGP', // Example total price
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
