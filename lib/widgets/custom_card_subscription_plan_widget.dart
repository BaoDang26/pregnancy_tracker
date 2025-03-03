import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/num_utils.dart';

import '../controllers/subscription_plan_controller.dart';
import '../util/app_export.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final String name;
  final double price;
  final String description;
  final String duration;
  final String buttonText;
  final bool isPopular;
  final int index;
  // final Color backgroundColor;
  SubscriptionPlanCard({
    required this.name,
    required this.price,
    required this.description,
    required this.duration,
    required this.buttonText,
    required this.index,
    this.isPopular = false,
    // this.backgroundColor = Colors.white,
  });

  // Hàm format giá tiền
  // String formatPrice() {
  //   final formatter = NumberFormat('#,###', 'vi_VN');
  //   return '${formatter.format(price)} VND';
  // }

  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionPlanController());
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
                  Center(
                    child: Text(
                      'MOST POPULAR!',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: SelectableText(
                    "${price.round().formatWithThousandSeparator()} VND",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: SelectableText(
                    '${duration} days',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SelectableText(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
                // ...features.map((feature) => ListTile(
                //       leading: Icon(Icons.check, color: Colors.lightGreen),
                //       title: Text(feature),
                //     )),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final controller = Get.find<SubscriptionPlanController>();
                      controller.goToSubscriptionPlanDetail(index);
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
