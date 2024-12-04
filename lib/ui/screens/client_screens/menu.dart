import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/menu_category_Service.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:toastification/toastification.dart';
class MenuScreen extends StatefulWidget {
  final String restaurantId;

  const MenuScreen({super.key, required this.restaurantId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuCategory> categories = [];
  bool isLoading = true;
  String? restaurantId;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
  
    restaurantId = widget.restaurantId;
    try {
      List<MenuCategory> fetchedCategories =
          await CategoryService().fetchMenuCategories(restaurantId!);
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Failed to load categories');
    }
  }


   
  // Method to show error SnackBar
  void _showErrorSnackBar(String message) {
    toastification.show(
      context: context,
      title: Text('Error'),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                        ? Center(child: Text('No categories available'))
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Display 2 items per row
                                crossAxisSpacing: 16.0, // Space between columns
                                mainAxisSpacing: 16.0, // Space between rows
                                // childAspectRatio:
                                //     0.75, // Aspect ratio of each card
                              ),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                MenuCategory category = categories[index];
                                return MenuCatrgoeyItem(
                                  imageUrl: category.image,
                                  label: category.name,
                                  onPressed: () async {
                                    final result =
                                        await Navigator.of(context).pushNamed(
                                      '/menuItems',
                                      arguments: {
                                        'restaurantId': restaurantId!,
                                        'categoryId': category.id,
                                        'categoryName': category.name,
                                        'categoryDescription':
                                            category.description,
                                        'categoryImageUrl': category.image,
                                      },
                                    );
                                    if (result == true) {
                                      _fetchCategories();
                                    }
                                  },
                                );
                              },
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
