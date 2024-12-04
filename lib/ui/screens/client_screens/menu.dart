import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/services/menu_provider.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart';
import '../../../constants/app_colors.dart';
class MenuScreen extends StatefulWidget {
  final String restaurantId;

  const MenuScreen({super.key, required this.restaurantId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late MenuCategoryProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = MenuCategoryProvider();
    _fetchCategories(); // Initial fetch
  }



  void _fetchCategories() {
    _provider.fetchCategories(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<MenuCategoryProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Menu'),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              iconTheme: const IconThemeData(
                color: Colors.white, // Set the back button color to white
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.categories.isEmpty
                      ? const Center(child: Text('No categories available'))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                          ),
                          itemCount: provider.categories.length,
                          itemBuilder: (context, index) {
                            MenuCategory category = provider.categories[index];
                            return MenuItem(
                              imageUrl: category.image,
                              label: category.name,
                              onPressed: () {
                                print('Clicked on ${category.name}');
                              },
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}
