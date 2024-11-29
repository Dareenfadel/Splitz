import 'package:flutter/material.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/data/services/restaurant_service.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:splitz/constants/app_colors.dart';


class ClientHome extends StatefulWidget {
  const ClientHome({Key? key}) : super(key: key);

  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final RestaurantService _restaurantService = RestaurantService();
  final AuthService _auth = AuthService();
  late Future<List<Restaurant>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch restaurants
    _restaurantsFuture = _restaurantService.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Home',
          style: TextStyle(color: AppColors.textColor),
        ),
      
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No restaurants available'),
            );
          }
              


          // Data is available
          final restaurants = snapshot.data!;
          // Extract sections
          final offers = restaurants
              .where((r) => r.menuCategories.any((c) => c.name.toLowerCase() == 'offers' && c.itemIds.isNotEmpty))
              .toList();
          
          final topRatedRestaurants = restaurants
              .toList()
            ..sort((a, b) => b.overallRating.compareTo(a.overallRating));
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offers Section
                _buildOffersSection(offers),
                const SizedBox(height: 20),
                // Top Restaurants Section
                _buildTopRatedSection(topRatedRestaurants),
                const SizedBox(height: 20),
                // More Restaurants Section
                _buildMoreRestaurantsSection(restaurants),
              ],
            ),
          );
        },
      ),
    );
  }
Widget _buildOffersSection(List<Restaurant> offers) {
  // Extracting offer images and titles
  final List<Widget> offerCards = offers.map((restaurant) {
    final category = restaurant.menuCategories.firstWhere(
      (c) => c.name.toLowerCase() == 'offers',
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
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
              category.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Restaurant Name Overlay
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Offers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft, // Align the carousel to the right
        child: CarouselSlider(
          items: offerCards,
          options: CarouselOptions(
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
  
  Widget _buildTopRatedSection(List<Restaurant> topRated) {
    final top5 = topRated.take(5).toList(); // Get top 5 restaurants
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Top Rated Restaurants',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 160, // Adjust based on your layout
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: top5.length,
            itemBuilder: (context, index) {
              final restaurant = top5[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle restaurant tap
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          restaurant.image,
                          width: 120,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rating: ${restaurant.overallRating.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 12),
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

  Widget _buildMoreRestaurantsSection(List<Restaurant> moreRestaurants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'More Restaurants',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: moreRestaurants.length,
          itemBuilder: (context, index) {
            final restaurant = moreRestaurants[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(restaurant.name),
              subtitle: Text('Rating: ${restaurant.overallRating.toStringAsFixed(1)}'),
              onTap: () {
                // Handle restaurant tap (e.g., navigate to details)
              },
            );
          },
        ),
      ],
    );
  }
}
