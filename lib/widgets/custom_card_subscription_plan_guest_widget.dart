import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';

import '../util/app_export.dart';

class SubscriptionPlanGuestCard extends StatelessWidget {
  final String title;
  final String price;
  final String details;
  final List<String> features;
  final String buttonText;
  final bool isPopular;
  // final Color backgroundColor;
  SubscriptionPlanGuestCard({
    required this.title,
    required this.price,
    required this.details,
    required this.features,
    required this.buttonText,
    this.isPopular = false,
    // this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[300]!, Colors.blue[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  const Center(
                    child: const Text(
                      'MOST POPULAR!',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    details,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...features.map((feature) => ListTile(
                      leading:
                          const Icon(Icons.check, color: Colors.lightGreen),
                      title: Text(feature),
                    )),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
