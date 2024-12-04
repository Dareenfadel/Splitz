import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/menu_item_service.dart';
import 'package:splitz/ui/custom_widgets/custom_floating_button.dart';
import 'package:toastification/toastification.dart';

class AllItemsScreen extends StatefulWidget {
  final String restaurantId;
  final String categoryId;

  const AllItemsScreen({
    Key? key,
    required this.restaurantId,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  // Default placeholder image
  final String defaultImageUrl =
      'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';

  // Fetch Items function (returns Future)
  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final fetchedItems = await MenuItemService().fetchAllItems(
        widget.restaurantId,
      );

      return fetchedItems
          .map<Map<String, dynamic>>((item) => {
                'id': item.id,
                'name': item.name,
                'image': item.image == '' ? defaultImageUrl : item.image,
                'rating': item.overallRating,
                'price': item.price,
                'description': item.description ?? '',
                'deliveryTime': item.preparationTime ?? 'N/A',
                'discount': item.discount ?? '',
              })
          .toList();
    } catch (e) {
      throw 'Failed to fetch items: $e';
    }
  }

  void onMenuItemTap(String? itemId) async {
    MenuItemModel? item = await MenuItemService()
        .fetchMenuItemWithDetails(widget.restaurantId, itemId!);
    final result = await Navigator.of(context).pushNamed(
      '/add-item',
      arguments: {
        'restaurantId': widget.restaurantId,
        'menuItem': item,
        'categoryId': widget.categoryId
      },
    );

    if (result == true) {
      setState(() {});
    }
  }

  void handleDeletion(String id) async {
    await MenuItemService().deleteMenuItem(widget.restaurantId, id);
    setState(() {});
    toastification.show(
      context: context,
      title: Text('Menu Item Removed!'),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.green,
    );
  }

  void addItemToCategory(String id) async {
    await MenuItemService()
        .addNewItemToCategory(widget.restaurantId, widget.categoryId, id);
    setState(() {});
    toastification.show(
      context: context,
      title: Text('Menu Item is Added to the Category!'),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check),
      showIcon: true, // show or hide the icon
      primaryColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Savor the Flavors: Full Menu',
          style: TextStyle(color: AppColors.primary, fontSize: 20),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context, true)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Fetch items asynchronously
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No items found, show category card with info
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Center(child: Text('No items In Restaurant yet.')),
                  ],
                ),

                // Floating button always visible for managers
                Provider.of<UserModel?>(context)?.userType == "manager"
                    ? CustomFloatingButton(
                        onPressed: () async {
                          final result = await Navigator.of(context)
                              .pushNamed('/add-item', arguments: {
                            'restaurantId': widget.restaurantId,
                            'categoryId': widget.categoryId,
                          });

                          if (result == true) {
                            setState(() {});
                          }
                        },
                      )
                    : SizedBox.shrink(),
              ],
            );
          } else {
            final items = snapshot.data!;
            return Stack(
              children: [
                Column(
                  children: [
                    // Category Card Section
                    const SizedBox(height: 20),
                    // Item List Section
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return GestureDetector(
                            onTap: () => onMenuItemTap(item['id']),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Card(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        item['image'],
                                        height: 170,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Details Section
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item['description'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${item['price']} EGP',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${item['rating']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[700],
                                                  size: 18.0,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(children: [
                                              Icon(
                                                Icons.av_timer,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                '${item['deliveryTime']}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ])
                                          ],
                                        ),
                                      ),
                                    ),

                                    if (Provider.of<UserModel?>(context)
                                            ?.userType ==
                                        "manager")
                                      IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: AppColors.primary,
                                          ),
                                          onPressed: () async {
                                            addItemToCategory(item['id']);
                                          }),
                                    if (Provider.of<UserModel?>(context)
                                            ?.userType ==
                                        "manager")
                                      IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            color: AppColors.primary,
                                          ),
                                          onPressed: () async {
                                            handleDeletion(item['id']);
                                          }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Floating button always visible for managers
                CustomFloatingButton(
                  onPressed: () async {
                    final result = await Navigator.of(context)
                        .pushNamed('/add-item', arguments: {
                      'restaurantId': widget.restaurantId,
                      'categoryId': widget.categoryId,
                    });

                    if (result == true) {
                      setState(() {});
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
