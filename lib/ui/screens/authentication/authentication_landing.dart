import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/services/auth.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';

class Landing extends StatefulWidget {
  final Function toggleView;
  Landing({required this.toggleView});
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.white, // Keep the background white
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () async {
                  await _auth.signInAnnon(); // Handle anonymous sign-in
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Spacer to position the text correctly
          SizedBox(height: 60),
          // Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Easy dining, easy bill split, easy life :)",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Spacer for better spacing before the image
          SizedBox(height: 30),
          // Circle Image Carousel
          SizedBox(
            width: 300,
            height: 300,
            child: ClipOval(
              child: PageView(
                controller: _pageController,
                children: [
                  Image.asset('lib/assets/images/burger.jpg',
                      fit: BoxFit.cover),
                  Image.asset('lib/assets/images/burger2.jpg',
                      fit: BoxFit.cover),
                  Image.asset('lib/assets/images/burger.jpg',
                      fit: BoxFit.cover),
                ],
              ),
            ),
          ),
          // Page Indicator

          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double selected = (_pageController.page ?? 0) - index;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: selected.abs() < 0.5 ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: selected.abs() < 0.5
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
            child: Column(
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    widget.toggleView(1);
                  },
                  text: 'Login',
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  text: 'Create an Account',
                  onPressed: () {
                    widget.toggleView(2);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40), // Add some space below the buttons
        ],
      ),
    );
  }
}
