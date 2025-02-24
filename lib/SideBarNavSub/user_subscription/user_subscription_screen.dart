import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import '../../widgets/custom_card_subscription_plan_widget.dart';

class UserSubscriptionScreen extends StatelessWidget {
  const UserSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Subscription Plans'),
      // ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SUBSCRIPTION PLANS',
              style: TextStyle(
                fontSize: 47, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              // Ensure GridView takes available space
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Số cột
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.1, // Tỉ lệ chiều rộng/chiều cao
                ),
                itemCount: 5, // Số lượng gói
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // controller.goToBlogDetail(index);
                    },
                    child: AspectRatio(
                      aspectRatio:
                          1.0, // Adjust this ratio to fit the Container
                      child: Stack(
                        children: [
                          SubscriptionPlanCard(
                            title: 'Pro',
                            price: '\$25',
                            details:
                                '\$30 USD if billed monthly\n3 Licenses Minimum',
                            features: [
                              'All Standard plan features, plus:',
                              'CRM integrations',
                              'Unlimited meetings',
                              'Hold queues',
                              'Zapier, Zendesk, Slack integrations',
                            ],
                            buttonText: 'Subscribe',
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
