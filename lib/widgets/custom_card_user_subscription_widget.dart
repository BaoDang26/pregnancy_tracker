import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/num_utils.dart';

import '../util/app_export.dart';

class UserSubscriptionCard extends StatelessWidget {
  final String subscriptionPlanName;
  final DateTime startDate;
  final DateTime endDate;
  final int amount;
  final String subscriptionCode;
  // final String buttonText;
  final String status;
  // final Color backgroundColor;
  UserSubscriptionCard({
    required this.subscriptionPlanName,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.subscriptionCode,
    // required this.buttonText,
    required this.status,
    // this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow[300]!, Colors.yellow[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (isPopular)
                //   Center(
                //     child: Text(
                //       'MOST POPULAR!',
                //       style: TextStyle(
                //         color: Colors.purple,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                Center(
                  child: Text(
                    subscriptionPlanName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "${amount.round().formatWithThousandSeparator()} VND",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subscription Code:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SelectableText(
                      subscriptionCode,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Start Date:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SelectableText(
                      startDate.format(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Date:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SelectableText(
                      endDate.format(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SelectableText(
                      status,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                // ...features.map((feature) => ListTile(
                //       leading: Icon(Icons.check, color: Colors.lightGreen),
                //       title: Text(feature),
                //     )),
                // SizedBox(height: 10),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // Get.toNamed(AppRoutes.subscriptionplandetail);
                //     },
                //     child: Text(buttonText),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
