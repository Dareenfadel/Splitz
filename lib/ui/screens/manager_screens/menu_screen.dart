import 'package:flutter/material.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/services/menu_category_Service.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart';

class MenuScreen extends StatelessWidget {
  String restaurantId = "";

  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    restaurantId = "ZVCMxkUQjp6zcYv6NlYH"; //hard coded need to be passed later
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
      child: FutureBuilder<List<MenuCategory>>(
        future: _categoryService.fetchMenuCategories(restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading categories'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No categories available'),
            );
          }

          // Fetched categories
          List<MenuCategory> categories = snapshot.data!;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              MenuCategory category = categories[index];
              return MenuItem(
                imageUrl: category.image, // Use the category image URL
                label: category.name,
                onPressed: () {
                  print('Clicked on ${category.name}');
                  // Navigate to category details or perform another action
                },
              );
            },
          );
        },
      ),
    );
  }
}
