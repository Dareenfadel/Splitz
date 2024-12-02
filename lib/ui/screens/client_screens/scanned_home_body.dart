import 'package:flutter/material.dart';
import 'package:splitz/data/services/restaurant_service.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:splitz/data/models/menu_item.dart';
import '../../../constants/app_colors.dart';
import 'qr_scan.dart';


//TODO: Implement the ScannedHomeBody class
//TODO: FIX PRICE IN FLOATING BTN
//TODO:View all restaurannts guest
//TODO VIEW MENU/MENU ITEMS
//TODO  VIEW MY CART ORDERS (AD,DEL,EDIT)
//REDIRECT TO SCANNED HOMEPAGE IF ALREADY SCANNED
//HOME PAGE REIRECT TO REST MENU/OFFER

class ScannedHomeBody extends StatelessWidget {
  String restaurantId;
  ScannedHomeBody({required this.restaurantId});

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
      body: const Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// class ScannedHomeBody extends StatefulWidget {
//   String restaurantId;
//   ScannedHomeBody({required this.restaurantId});

//   @override
//   State<ScannedHomeBody> createState() => _ScannedHomeBodyState();
// }

// class _ScannedHomeBodyState extends State<ScannedHomeBody> {
//   final RestaurantService _restaurantService = RestaurantService();
//   late Future _restaurantDataFuture;
//  @override
//   void initState() {
//     // print('in init state');
//     super.initState();
//     _fetchRestaurantData();  // Call this method to fetch restaurants
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//         _fetchRestaurantData();
//   }

//   void _fetchRestaurantData()  async {
//     // print('in load retaurants');
//     setState(() {
//       _restaurantDataFuture = _restaurantService.fetchRestaurantById(widget.restaurantId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         centerTitle: true,
//         titleTextStyle: const TextStyle(
//           color: AppColors.textColor,
//           fontSize: 20,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       body: _getBody(),
//     );
//   }
//   Widget _getBody() {
//     return FutureBuilder<Restaurant>(
//       future: _restaurantDataFuture as Future<Restaurant>,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else if (!snapshot.hasData) {
//           return const Center(
//             child: Text('No data available'),
//           );
//         }

//         // Data is available
//         final restaurantData = snapshot.data!;
//         final offers = restaurantData.menuCategories.firstWhere(
//           (c) => c.name.toLowerCase() == 'offers',
//         ).itemIds.map((itemId) {
//           return restaurantData.menuItems.firstWhere((item) => item.id == itemId);
//         }).toList();
//         final mostPopularItems = restaurantData.menuItems
//           .where((item) => item.count != null)
//           .toList()
//           ..sort((a, b) => b.count!.compareTo(a.count!));

//         final moreRestaurants = _getmoreRestaurants(topRatedRestaurants, restaurants);

//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildOffersSection(offers),
//               const SizedBox(height: 20),
//               _buildRestaurantsSection(topRatedRestaurants, '🔥Top Rated Restaurants'),
//               const SizedBox(height: 20),
//               _buildRestaurantsSection(moreRestaurants, 'More Restaurants'),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildOffersSection(List<Restaurant> offers) {
//   // print(offers);
//   // Extracting offer images and titles
//   final List<Widget> offerCards = offers.map((restaurant) {
//     final category = restaurant.menuCategories.firstWhere(
//       (c) => c.name.toLowerCase() == 'offers',
//     );
//     final offerItemId=category.itemIds.last;
//     final offerItem=restaurant.menuItems.firstWhere((item) => item.id == offerItemId);
//     return GestureDetector(
//               onTap: () {
//                 _goToRestaurantDetails(restaurant); // Call the function when the card is tapped
//               },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.0),
//           color: AppColors.textColor,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 4,
//               offset: const Offset(0, 2), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Offer Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12.0),
//               child: Image.network(
//                 offerItem.image,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//             // Restaurant Name Overlay
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.0),
//                   gradient: LinearGradient(
//                     colors: [Colors.black54, Colors.transparent],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   restaurant.name,
//                   style: const TextStyle(
//                     color: AppColors.textColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }).toList();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           '💥Offers',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//       Align(
//         alignment: Alignment.centerLeft, // Align the carousel to the right
//         child: CarouselSlider(
//           items: offerCards,
//           options: CarouselOptions(
//             padEnds: true, // Add padding at the end of the carousel
//             height: 200, // Adjust height based on design
//             viewportFraction: 0.85, // Show part of the next card
//             enlargeCenterPage: false, // Disable centering the current card
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 5),
//             enableInfiniteScroll: true, // Loop offers
//           ),
//         ),
//       ),
//     ],
//   );
// }
  
//   // Widget _buildTopRatedSection(List<Restaurant> topRated) {
//   //   final top5 = topRated.take(5).toList(); // Get top 5 restaurants
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       const Padding(
//   //         padding: EdgeInsets.all(8.0),
//   //         child: Text(
//   //           'Top Rated Restaurants',
//   //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//   //         ),
//   //       ),
//   //       SizedBox(
//   //         height: 160, // Adjust based on your layout
//   //         child: ListView.builder(
//   //           scrollDirection: Axis.horizontal,
//   //           itemCount: top5.length,
//   //           itemBuilder: (context, index) {
//   //             final restaurant = top5[index];
//   //             return Padding(
//   //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//   //               child: GestureDetector(
//   //                 onTap: () {
//   //                   // Handle restaurant tap
//   //                 },
//   //                 child: Column(
//   //                   children: [
//   //                     ClipRRect(
//   //                       borderRadius: BorderRadius.circular(12),
//   //                       child: Image.network(
//   //                         restaurant.image,
//   //                         width: 120,
//   //                         height: 100,
//   //                         fit: BoxFit.cover,
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 8),
//   //                     Text(
//   //                       restaurant.name,
//   //                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//   //                     ),
//   //                     Text(
//   //                       'Rating: ${restaurant.overallRating.toStringAsFixed(1)}',
//   //                       style: const TextStyle(fontSize: 12),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //             );
//   //           },
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
// Widget _buildRestaurantsSection(List<Restaurant> topRated, String sectionTitle) {
//   final top5 = topRated.take(5).toList(); // Get top 5 restaurants

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Section Title
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           sectionTitle,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Larger font
//         ),
//       ),
//       // Horizontal Scrolling List
//       SizedBox(
//         height: 210, // Adjusted height to reduce white space
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal, // Enable horizontal scrolling
//           itemCount: top5.length,
//           itemBuilder: (context, index) {
//             final restaurant = top5[index];

//             // Card Design
//             return GestureDetector(
//               onTap: () {
//                 _goToRestaurantDetails(restaurant); // Call the function when the card is tapped
//               },
//               child: Container(
//                 width: 200, // Adjust width for each card
//                 margin: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 6.0), // Spacing between cards
//                 decoration: BoxDecoration(
//                   color: AppColors.textColor,
//                   borderRadius: BorderRadius.circular(10.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5), // Increased opacity for a darker shadow
//                       blurRadius: 5.0, // Increased blur radius for a larger shadow
//                       offset: const Offset(0, 3), // Lowered the shadow position
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Restaurant Image with Circular Edges
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0), // Added spacing above the image
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12.0), // Circular edges for the image
//                         child: Image.network(
//                           restaurant.image,
//                           height: 140, // Adjust image height
//                           width: 180, // Adjust image width
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     // Restaurant Details
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Adjusted padding
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             restaurant.name,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 16, // Larger font size for name
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 1, // Prevent text overflow
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 4.0), // Reduced space between name and rating
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.star, color: Colors.amber, size: 18),
//                               const SizedBox(width: 4.0),
//                               Text(
//                                 restaurant.overallRating.toStringAsFixed(1),
//                                 style: const TextStyle(fontSize: 14), // Adjusted font size for rating
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }

// List<Restaurant>_getmoreRestaurants(List<Restaurant> topRatedRestaurants, List<Restaurant> restaurants) {
// final List<Restaurant> randomRestaurants = [];
// final List<Restaurant> nonTopRatedRestaurants = restaurants.where((restaurant) => !topRatedRestaurants.contains(restaurant)).toList();

// if (nonTopRatedRestaurants.length >= 5) {
//   // If there are enough non-top-rated restaurants, pick 5 randomly
//   while (randomRestaurants.length < 5) {
//     final randomRestaurant = nonTopRatedRestaurants[DateTime.now().microsecondsSinceEpoch % nonTopRatedRestaurants.length];
//     if (!randomRestaurants.contains(randomRestaurant)) {
//       randomRestaurants.add(randomRestaurant);
//     }
//   }
// } else {
//   // If not enough non-top-rated, pick from both the non-top-rated and top-rated list to fill the 5
//   randomRestaurants.addAll(nonTopRatedRestaurants);
  
//   // Get the remaining needed count from the top-rated list
//   final remainingCount = 5 - randomRestaurants.length;
//   final topRatedRemaining = topRatedRestaurants.take(remainingCount).toList();
//   randomRestaurants.addAll(topRatedRemaining);
// }
// return randomRestaurants;
// }
// void _goToRestaurantDetails(Restaurant restaurant) {
//   // Navigate to the restaurant details screen
//   print('Navigating to ${restaurant.name}');
// }
// Widget floatingActionButton() {
//   return 
//     Padding(
//       padding: const EdgeInsets.only(bottom: 16.0), // Add padding for better positioning
//       child: FloatingActionButton(
//         // onPressed: () async {
//         //   print('QR Code Scanner Floating Action Button Pressed');
//         //   // Navigate to the QR scan page
//         //   final result = await Navigator.push(
//         //     context,
//         //     MaterialPageRoute(builder: (context) => QrCodeScanner()),
//         //   );
//         //   // Handle the result if needed
//         //   if (result != null) {
//         //     print('Scanned QR Code: $result');
//         //   }
//         // },
//         onPressed: () {
//           // Handle the floating action button press
//           print('QR Code Scanner Floating Action Button Pressed');
//         },
//         child: const Icon(Icons.qr_code, color: Colors.white), // QR icon
//         backgroundColor: AppColors.textColor, // You can change the background color
      
//     ),
//   );
// }
// }
