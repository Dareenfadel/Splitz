import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardsLoadingScreen extends StatelessWidget {
  final int cardCount;

  const CardsLoadingScreen({
    super.key,
    this.cardCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cardCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                  color: Colors.white,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 14,
                                      color: Colors.grey.withOpacity(0.9),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 150,
                                      height: 12,
                                      color: Colors.grey.withOpacity(0.9),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Multiple lines of content
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 16,
                            color: Colors.grey.withOpacity(0.9),
                          ),
                          const SizedBox(height: 16),
                          // Action buttons placeholder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }
}
