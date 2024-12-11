import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/menu_category_Service.dart';
import 'package:splitz/ui/custom_widgets/custom_floating_button.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart';
import 'package:splitz/ui/screens/manager_screens/menu_screens/add_category_dialog.dart';
import 'package:toastification/toastification.dart';

class MenuScreen extends StatefulWidget {
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
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null || user.restaurantId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    restaurantId = user.restaurantId;
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

  // Method to add a new category
  void _addCategory(MenuCategory newCategory) async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null || user.restaurantId == null) {
      _showErrorSnackBar('Failed to add category');
      return;
    }

    try {
      await CategoryService().addMenuCategory(
        user.restaurantId!,
        newCategory.name,
        newCategory.description,
        newCategory.image,
      );
      _fetchCategories();
    } catch (e) {
      _showErrorSnackBar('Failed to add category');
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
    final user = Provider.of<UserModel?>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
                                        'restaurantId': user?.restaurantId!,
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
            if (user?.userType == "manager")
              CustomFloatingButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddCategoryDialog(
                      restaurantId: user?.restaurantId ?? '',
                      onCategoryAdded: (newCategory) {
                        _addCategory(newCategory);
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
