import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:splitz/data/services/restaurant_service.dart';  
import 'package:url_launcher/url_launcher.dart';
import 'package:splitz/ui/screens/client_screens/menu.dart';
class AllRestaurantsScreen extends StatefulWidget {
  const AllRestaurantsScreen({super.key});

  @override
  State<AllRestaurantsScreen> createState() => _AllRestaurantsScreenState();
}

class _AllRestaurantsScreenState extends State<AllRestaurantsScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _allRestaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // print('init');
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final restaurants = await _restaurantService.fetchRestaurants();
    setState(() {
      _allRestaurants = restaurants;
      _filteredRestaurants = restaurants;
    });
  }

  void _filterRestaurants(String query) {
    setState(() {
      _filteredRestaurants = _allRestaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('All Restaurants'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
    ),
    body: Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: 
            Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
              ),
            ],
            ),
            child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Find a restaurant...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            onChanged: _filterRestaurants,
            ),
                  ),
          
        ),

  Expanded(
    child: Column(
        children: [
          Expanded(
            child: _filteredRestaurants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading restaurants...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: _filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = _filteredRestaurants[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: InkWell(
  onTap: () {
    // Add your navigation or action here
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(
          restaurantId: restaurant.id!,
          restaurantName: restaurant.name,
        ),
      ),
    );
  },
  
  
                       
                          borderRadius: BorderRadius.circular(20),
                          
                            child: Container(
                              child: Card(

                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.1),),
                                ),
                              elevation: 0,
                              child: Column(
                                children: [
                                Stack(
                                  children: [
                                  Hero(
                                    tag: 'restaurant_${restaurant.id}',
                                    child: restaurant.image.isNotEmpty
                                      ? Image.network(
                                        restaurant.image,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                          height: 200,
                                          color: Colors.grey[100],
                                          child: Icon(Icons.restaurant,
                                            size: 80,
                                            color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5)),
                                          ),
                                      )
                                      : Container(
                                        height: 200,
                                        color: Colors.grey[100],
                                        child: Icon(Icons.restaurant,
                                          size: 80,
                                          color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5)),
                                      ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                      ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                      const Icon(Icons.star,
                                        size: 20, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.overallRating
                                          .toStringAsFixed(1),
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                    child: Text(
                                      restaurant.name,
                                      style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 0.5,
                                      ),
                                    ),
                                    ),
                                    IconButton(
                                    onPressed: () => _launchMaps(restaurant.address),
                                    icon: Icon(
                                      Icons.directions,
                                      color: Theme.of(context).primaryColor,
                                      size: 28,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.secondary.withOpacity(0.5),
                                      padding: const EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    ),
                                  ],
                                  ),
                                ),
                                ],
                              
                              ),
                            ),
                          ),
                        ),
                          );
                        },
                        ),
                    ),
                  ],
                  ),
                ),
                  ],
                ),
  );
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
void _launchMaps(String? address) async {
  // debugPrint('$address  address');
   if (address == null || address.isEmpty) {
  address = 'https://maps.app.goo.gl/oae9iZmJbc7K8pGM9';
   }
  // debugPrint('Launching maps for: $address');
  if (await canLaunch(address)) {
    await launch(address);
   }
  else {
    debugPrint('Could not launch $address');
  }
}
}