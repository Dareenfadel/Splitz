import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/services/menu_item_service.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/choice.dart';
import 'package:splitz/data/services/order_item_service.dart';
import 'package:splitz/constants/app_colors.dart';

class AddToCartScreen extends StatefulWidget {
  final String restaurantId;
  final String? menuItemId;
  final String? orderId;
  final int? orderItemInd; //for update order item

  const AddToCartScreen(
      {Key? key, required  this.restaurantId,  this.menuItemId, this.orderId,this.orderItemInd})
      : super(key: key);

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final MenuItemService _menuItemService = MenuItemService();
  MenuItemModel? menuItem;
  bool isLoading = true;
  Map<String, String> selectedOptions = {};
  Map<String, int> selectedExtras = {};
  double totalPrice = 0.0;
  String specialInstructions = '';
  String? restaurantId;
  String? menuItemId;
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      // If orderId exists, fetch the order details first to get restaurantId and menuItemId
       _fetchOrderDetails();
       
      
    } else {
      restaurantId = widget.restaurantId;
      menuItemId = widget.menuItemId;
      _fetchMenuItemDetails();
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      print('Fetching order details');
      final orderDetails = await OrderService().getOrderItemDetails(widget.orderId!,widget.orderItemInd!);
    
      setState(() {
      
        menuItemId = orderDetails?.itemId;
        specialInstructions = orderDetails.notes;
        selectedExtras = orderDetails.extras;
        selectedOptions = orderDetails.options;
        totalPrice = orderDetails.price;
        _controller.text = specialInstructions ?? '';
        print('Total Price: $totalPrice');
      });
      await _fetchMenuItemDetails();
       
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  bool areAllRequiredOptionsSelected() {
  if (menuItem == null) return false;
  
  // Check if we have a selection for each required option
  for (var option in menuItem!.requiredOptions) {
    if (!selectedOptions.containsKey(option.name) || selectedOptions[option.name]!.isEmpty) {
      return false;
    }
  }
  return true;
}


  Future<void> _fetchMenuItemDetails() async {
    try {
      final item = await _menuItemService.fetchMenuItemWithDetails(
          widget.restaurantId!, menuItemId!);
      setState(() {
        menuItem = item;
        isLoading = false;
        if(totalPrice == 0.0)
        totalPrice = item!.price ?? 0.0;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching menu item details: $e');
    }
  }

  double calculateTotalPrice() {
    if (menuItem == null) return 0.0;

    double total = menuItem!.price;

    // Add required options prices
    for (var option in menuItem!.requiredOptions) {
      String? selectedChoice = selectedOptions[option.name];
      if (selectedChoice != null) {
        var choice = option.choices.firstWhere(
          (c) => c.name == selectedChoice,
          orElse: () => Choice(name: '', price: 0),
        );
        total += choice.price;
      }
    }

    // Add extras prices
    selectedExtras.forEach((extraName, quantity) {
      var extra = menuItem!.extras.firstWhere(
        (e) => e.name == extraName,
        orElse: () => Extra(name: '', price: 0),
      );
      total += extra.price * quantity;
    });

    return total;
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = calculateTotalPrice();
    });
  }
  void updateCartItem() async {
    try {
      final OrderItem updatedItem = OrderItem(
        itemId: menuItem!.id,
        itemName: menuItem!.name,
        imageUrl: menuItem!.image,
        quantity: 1,
        extras: selectedExtras,
        notes: specialInstructions,
        paidAmount: 0,
        paidUsers: {},
        prepared: false,
        price: totalPrice,
        userList: [
          OrderItemUser(
            userId: FirebaseAuth.instance.currentUser!.uid,
            requestStatus: 'accepted'
          )
        ],
        status: 'ordering',
        options: selectedOptions,
      );

      await OrderService().updateItemInOrder(widget.orderId!, updatedItem,widget.orderItemInd!);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item: $e'))
      );
    }
  }

  void addItemToOrder() async {
    final OrderItem newItem = OrderItem(
                        itemId: menuItem!.id,
                        itemName: menuItem!.name,
                        imageUrl: menuItem!.image,
                        quantity: 1,
                        extras: selectedExtras,
                        notes: specialInstructions,
                        paidAmount: 0,
                        paidUsers: {},
                        prepared: false,
                        price: totalPrice,
                        userList: [
                          OrderItemUser(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            requestStatus: 'accepted'
                          )
                        ],
                        status: 'ordering',
                        options: selectedOptions,
                      );

                      try {
                        await OrderService().addItemToOrder(
                          FirebaseAuth.instance.currentUser!.uid,
                          newItem
                        );
                        await MenuItemService().incrementCount(
                          widget.restaurantId!,
                          menuItemId!,
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding item to order: $e'))
                        );
                      }
                    }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (menuItem == null) {
      return const Scaffold(
        body: Center(child: Text('Error loading menu item')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem!.name, style: TextStyle(color: AppColors.primary)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.primary), // Added this line to change back button color
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(menuItem!.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Item Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(
                            menuItem!.name,
                            style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                              fontWeight: FontWeight.bold,
                              ),
                          ),
                            Text(
                            'EGP ${menuItem!.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                              fontWeight: FontWeight.bold,
                              
                              ),
                          ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          menuItem!.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(
                                                Icons.av_timer,
                                                size: 20,
                                                color: AppColors.primary,
                                              ),
                          const SizedBox(width: 8),
                          Text('${menuItem!.preparationTime} mins'),
                          const SizedBox(width: 24),
                          Icon(Icons.local_fire_department,
                           color:   AppColors.primary,),
                          const SizedBox(width: 8),
                          Text('${menuItem!.calories} cal'),
                          ],
                        ),
                        const Divider(height: 32),

                        // Required Options
                        if (menuItem!.requiredOptions.isNotEmpty) ...[
                          Text(
                            'Customize Your Order',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          ...menuItem!.requiredOptions.map((optionGroup) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                // color: AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(0, 0, 0, 0)
                                      .withOpacity(0.05),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(0, 0, 0, 0)
                                          .withOpacity(0.05),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Icon(Icons.restaurant_menu,
                                        // color: AppColors.primary,
                                        // size: 20,
                                        // ),
                                        const SizedBox(width: 2),
                                        Text(
                                          optionGroup.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                // color: AppColors.primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...optionGroup.choices.map((choice) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor:
                                            AppColors.primary.withOpacity(0.5),
                                      ),
                                      child: RadioListTile<String>(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              choice.name,
                                              style: TextStyle(
                                                fontWeight: selectedOptions[
                                                            optionGroup.name] ==
                                                        choice.name
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  90, // Fixed width for price container
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'EGP ${choice.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        value: choice.name,
                                        groupValue:
                                            selectedOptions[optionGroup.name],
                                        activeColor: AppColors.primary,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOptions[optionGroup.name] =
                                                value!;
                                            updateTotalPrice();
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          }).toList(),
                        ],

                        // Extras
                        if (menuItem!.extras.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Extras',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          ...menuItem!.extras.map((extra) {
                            return Column(
                              children: [
                                Container(
                                  // margin: const EdgeInsets.only(bottom: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                extra.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Text(
                                                'EGP ${extra.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                icon: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  // border: Border.all(color: AppColors.primary),
                                                  borderRadius: BorderRadius.circular(4),
                                                  color:const Color.fromARGB(0, 0, 0, 0)
                                      .withOpacity(0.05),
                                                ),
                                                child: Icon(Icons.remove,
                                                  color: AppColors.primary,
                                                  size: 20),
                                                ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedExtras[extra.name] =
                                                      (selectedExtras[extra.name] ??
                                                              0) -
                                                          1;
                                                  if (selectedExtras[extra.name]! <
                                                      0) {
                                                    selectedExtras[extra.name] = 0;
                                                  }
                                                  updateTotalPrice();
                                                });
                                              },
                                            ),
                                            Text(
                                              '${selectedExtras[extra.name] ?? 0}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            IconButton(
                                                icon: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  // border: Border.all(color: AppColors.primary),
                                                  borderRadius: BorderRadius.circular(4),
                                                  color:const Color.fromARGB(0, 0, 0, 0)
                                      .withOpacity(0.05),
                                                ),
                                                child: Icon(Icons.add,
                                                  color: AppColors.primary,
                                                  size: 20),
                                                ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedExtras[extra.name] =
                                                      (selectedExtras[extra.name] ??
                                                              0) +
                                                          1;
                                                  updateTotalPrice();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(thickness: 1),
                              ],
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                     Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Instructions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                TextField(
                  maxLines: 3,
                 controller: _controller,
                  decoration: InputDecoration(
                  hintText: 'Add any special instructions or notes here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.05),
                  filled: true,
                  ),
                  onChanged: (value) {
                  setState(() {
                    specialInstructions = value;
                  });
                  },
                ),
                const SizedBox(height: 16),
                ],
              ),
          ),
                ],
              ),
            ),
          ),
          // Bottom Bar
          // Notes Section
       
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'EGP ${totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: areAllRequiredOptionsSelected() 
                    ? AppColors.primary 
                    : AppColors.primary.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  ),
                  onPressed: areAllRequiredOptionsSelected() 
                  ? (widget.orderId != null ? updateCartItem : addItemToOrder) 
                  : null,
                  child: Text(
                  widget.orderId != null ? 'Update Cart' : 'Add to Cart',
                  style: TextStyle(
                    color: areAllRequiredOptionsSelected()
                    ? AppColors.textColor
                    : Colors.black.withOpacity(0.3),
                    fontSize: 18,
                  ),
                  ),
                ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
