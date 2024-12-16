import 'package:flutter/material.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart';
import 'package:splitz/data/services/menu_category_Service.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:toastification/toastification.dart';

import 'package:splitz/ui/screens/manager_screens/menu_screens/menuItems_of_category_screen.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final String? restaurantName;

  const MenuScreen({super.key, required this.restaurantId, this.restaurantName});

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
    
    // Sort categories to put "Offers" first
    fetchedCategories.sort((a, b) {
      if (a.name.toLowerCase() == 'offers') return -1;
      if (b.name.toLowerCase() == 'offers') return 1;
      return 0;
    });
  

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
      title: const Text('Error'),
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
        title: widget.restaurantName!=null?  Text(widget.restaurantName!): const Text('Menu'),
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
                        ? Center(child: const Text('No categories available'))
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryItemsPage(
                                                categoryId: category.id ?? "",
                                                restaurantId: restaurantId!,
                                                categoryName: category.name,
                                                categoryDescription:
                                                    category.description,
                                                categoryImageUrl:
                                                    category.image,
                                              )),
                                    );
                                    //testtt
                                    //  Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => AddToCartScreen(
                                    //           restaurantId: widget.restaurantId,
                                    //          orderId: "56hhmqwCruicNwKGnw1H",
                                    //          orderItemInd: 6,
                                    //         ),
                                    //       ),
                                    //     );
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
