import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/restaurant.dart';
import 'package:splitz/data/services/restaurant_service.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:splitz/ui/screens/wrapper.dart';

class RateRestaurantScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  RateRestaurantScreen(
      {required this.restaurantId, required this.restaurantName});

  @override
  _RateRestaurantScreenState createState() => _RateRestaurantScreenState();
}

class _RateRestaurantScreenState extends State<RateRestaurantScreen> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Restaurant', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How was your experience with ${widget.restaurantName}?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            PannableRatingBar(
              rate: _rating,
              items: List.generate(
                  5,
                  (index) => const RatingWidget(
                        selectedColor: Color.fromARGB(255, 255, 230, 0),
                        unSelectedColor: Colors.grey,
                        child: Icon(
                          Icons.star,
                          size: 48,
                        ),
                      )),
              onChanged: (value) {
                // the rating value is updated on tap or drag.
                setState(() {
                  _rating = value;
                });
              },
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  RestaurantService restaurantService = RestaurantService();
                  restaurantService.updateOverallRating(
                      widget.restaurantId, _rating);
                  print('User rated with $_rating stars');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Wrapper()), // The new page
                    (route) => false, // Remove all previous routes
                  );
                },
                text: "Confirm",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
