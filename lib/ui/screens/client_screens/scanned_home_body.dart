import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/services/restaurant_service.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/menu_category.dart';
import '../../../constants/app_colors.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart' as MenuItemWidget;


//TODO:View all restaurannts guest
//TODO VIEW MENU ITEMS
//TODO  VIEW MY CART ORDERS (AD,DEL,EDIT)
//REDIRECT TO SCANNED HOMEPAGE IF ALREADY SCANNED
//HOME PAGE REIRECT TO REST MENU/OFFER

class ScannedHomeBody extends StatefulWidget {
  final String restaurantId;
  final VoidCallback onNavigateToMenu;

   ScannedHomeBody({required this.restaurantId, required this.onNavigateToMenu});

  @override
  State<ScannedHomeBody> createState() => _ScannedHomeBodyState();
}

class _ScannedHomeBodyState extends State<ScannedHomeBody> {
  final RestaurantService _restaurantService = RestaurantService();
  late Future _restaurantDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantData(); // Call this method to fetch restaurants
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchRestaurantData();
  }

  void _fetchRestaurantData() async {
    setState(() {
      _restaurantDataFuture =
          _restaurantService.fetchRestaurantById(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return FutureBuilder<Restaurant>(
      future: _restaurantDataFuture as Future<Restaurant>,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('No data available'),
          );
        }

        // Data is available
        final restaurantData = snapshot.data!;
        List<MenuItem> offers = restaurantData.menuCategories
            .firstWhere(
              (c) => c.name.toLowerCase() == 'offers',
            )
            .itemIds
            .map((id) {
          return restaurantData.menuItems.firstWhere((item) => item.id == id);
        }).toList();
        List<MenuItem> mostPopularItems = restaurantData.menuItems.toList()
          ..sort((a, b) => b.count.compareTo(a.count));
        mostPopularItems.removeWhere((item) => offers.contains(item));
        final menuCategories = restaurantData.menuCategories
            .where((c) => c.name.toLowerCase() != 'offers')
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOffersSection(offers),
              const SizedBox(height: 20),
              _buildRestaurantsSection(mostPopularItems, '🔥Top Dishes'),
              const SizedBox(height: 20),
              _categoriesSection(menuCategories)
            ],
          ),
        );
      },
    );
  }

  Widget _buildOffersSection(List<MenuItem> offers) {
    final List<Widget> offerCards = offers.map((offerItem) {
      return GestureDetector(
        onTap: () {
          //   _goToRestaurantDetails(restaurant);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.textColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              // Offer Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  offerItem.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '💥Offers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft, // Align the carousel to the right
          child: CarouselSlider(
            items: offerCards,
            options: CarouselOptions(
              padEnds: true, // Add padding at the end of the carousel
              height: 200, // Adjust height based on design
              viewportFraction: 0.85, // Show part of the next card
              enlargeCenterPage: false, // Disable centering the current card
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enableInfiniteScroll: true, // Loop offers
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantsSection(
      List<MenuItem> topRated, String sectionTitle) {
    final top5 = topRated.take(5).toList(); // Get top 5 restaurants

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                sectionTitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold), // Larger font
              ),
            ),
            const Spacer(),
            // View All Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  widget.onNavigateToMenu();
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        // Horizontal Scrolling List
        SizedBox(
          height: 210, // Adjusted height to reduce white space
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            itemCount: top5.length,
            itemBuilder: (context, index) {
              final menuItem = top5[index];

              // Card Design
              return GestureDetector(
                onTap: () {
                  //  _goToRestaurantDetails(restaurant); // Call the function when the card is tapped
                },
                child: Container(
                  width: 200, // Adjust width for each card
                  margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 8.0,
                      bottom: 6.0), // Spacing between cards
                  decoration: BoxDecoration(
                    color: AppColors.textColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Restaurant Image with Circular Edges
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0), // Added spacing above the image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12.0), // Circular edges for the image
                          child: Image.network(
                            menuItem.image,
                            height: 140, // Adjust image height
                            width: 180, // Adjust image width
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Restaurant Details
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0), // Adjusted padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              menuItem.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16, // Larger font size for name
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // Prevent text overflow
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                                height:
                                    4.0), // Reduced space between name and rating
                            Text(
                              menuItem.description,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _categoriesSection(List<MenuCategory> menuCategories) {
    final top5 = menuCategories.take(5).toList(); // Get top 5 restaurants

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Menu Options',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold), // Larger font
          ),
        ),
        // Horizontal Scrolling List
        SizedBox(
          height: 180, // Adjusted height to reduce white space
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            itemCount: top5.length + 1,
            itemBuilder: (context, index) {
              return index < top5.length
                  ?

                  // Card Design
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MenuItemWidget.MenuItem(
                        imageUrl: top5[index].image,
                        label: top5[index].name,
                        onPressed: () {
                          print('Clicked on ${top5[index].name}');
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MenuItemWidget.MenuItem(
                        imageUrl: '',
                        label: 'View All',
                        onPressed: () {
                          widget.onNavigateToMenu();
                        },
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }


}