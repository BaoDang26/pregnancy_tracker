import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import '../../controllers/subscription_plan_controller.dart';
import '../../widgets/custom_card_subscription_plan_widget.dart';

class SubscriptionPlan extends GetView<SubscriptionPlanController> {
  const SubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Subscription Plans'),
      // ),
      body: Obx(() => Container(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Số cột
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.1, // Tỉ lệ chiều rộng/chiều cao
                    ),
                    itemCount: controller.subscriptionPlanList
                        .length, // Sử dụng độ dài từ controller
                    itemBuilder: (context, index) {
                      final plan = controller.subscriptionPlanList[
                          index]; // Lấy plan từ controller
                      return GestureDetector(
                        onTap: () {
                          controller.goToSubscriptionPlanDetail(index);
                        },
                        child: Container(
                          // Thay AspectRatio bằng Container
                          child: Stack(
                            children: [
                              SubscriptionPlanCard(
                                name: plan.name ?? '',
                                price: plan.price?.toDouble() ?? 0.0,
                                description: plan.description ?? '',
                                duration: plan.duration.toString(),
                                buttonText: 'Subscribe',
                                index: index,
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
          )),
    );
  }
}
