import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/util/num_utils.dart';

import '../../controllers/subscription_plan_controller.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:intl/intl.dart';

class SubscriptionPlan extends GetView<SubscriptionPlanController> {
  const SubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.85),
              foregroundColor: Colors.green[700],
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            onPressed: () {
              // Call the method to refresh the subscription plans
              controller
                  .getActiveSubscriptionPlanList(); // Assuming this method exists
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFC8E6C9),
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
              ),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F5E9),
                Color(0xFFC8E6C9),
                const Color(0xFFB2DFDB),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(context),

                // Info Banner
                _buildInfoBanner(),

                // Premium Features Section
                _buildPremiumFeatures(),

                // Subscription Plans Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: controller.activeSubscriptionPlanList.isEmpty
                        ? _buildEmptyState()
                        : _buildPlansList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF66BB6A),
            Color(0xFF4CAF50),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_membership,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Subscription Plans',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.85),
                    foregroundColor: Colors.green[700],
                  ),
                  icon: Icon(
                    Icons.history,
                    color: Colors.green[700],
                  ),
                  label: const Text('Subscription History'),
                  onPressed: () {
                    Get.toNamed(AppRoutes.usersubscription);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enhance your pregnancy journey with premium features',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.blue[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.blue[300]!.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[700],
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Choose a subscription plan to access all premium features and content',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No subscription plans available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: controller.activeSubscriptionPlanList.length,
      itemBuilder: (context, index) {
        final plan = controller.activeSubscriptionPlanList[index];
        return _buildSubscriptionCard(plan, index, context);
      },
    );
  }

  Widget _buildSubscriptionCard(dynamic plan, int index, BuildContext context) {
    // Define color schemes for different plans (alternating)
    final List<Color> cardColors = [
      Colors.blue[50]!,
      Colors.purple[50]!,
      Colors.amber[50]!,
    ];

    final List<Color> accentColors = [
      Colors.blue[700]!,
      Colors.purple[700]!,
      Colors.amber[700]!,
    ];

    final Color cardColor = cardColors[index % cardColors.length];
    final Color accentColor = accentColors[index % accentColors.length];

    final bool isPopular =
        index == 1; // Mark the second plan as popular for example

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Popular tag if applicable
            if (isPopular)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: Colors.orange[400],
                child: const Center(
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

            // Card Content
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor,
                    Colors.white,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative element
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plan name and icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getIconForPlan(plan.name ?? ''),
                                color: accentColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plan.name ?? 'Premium Plan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    '${plan.duration} days access',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${NumberFormat('#,###').format((plan.price ?? 0).round())}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'VND',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          plan.description ?? 'No description available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 20),

                        // Subscribe button
                        Visibility(
                          visible: !(controller.userRole.value ==
                              'ROLE_USER_PREMIUM'),
                          replacement: Container(
                            width: double.infinity,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Already Subscribed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.goToSubscriptionPlanDetail(index);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Choose Plan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get appropriate icon based on plan name
  IconData _getIconForPlan(String planName) {
    final name = planName.toLowerCase();

    if (name.contains('basic')) return Icons.star_outline;
    if (name.contains('standard')) return Icons.star_half;
    if (name.contains('premium')) return Icons.star;
    if (name.contains('pro')) return Icons.workspace_premium;
    if (name.contains('family')) return Icons.family_restroom;
    if (name.contains('monthly')) return Icons.calendar_month;
    if (name.contains('yearly')) return Icons.calendar_today;

    // Default icon if no match
    return Icons.card_membership;
  }

  Widget _buildPremiumFeatures() {
    // List of premium features
    final List<Map<String, dynamic>> premiumFeatures = [
      {
        'icon': Icons.favorite,
        'color': Colors.redAccent,
        'title': 'Advanced Health Tracking',
        'description': 'Detailed monitoring of baby health metrics'
      },
      // {
      //   'icon': Icons.article,
      //   'color': Colors.blueAccent,
      //   'title': 'Expert Content Access',
      //   'description': ''
      // },
      {
        'icon': Icons.monitor,
        'color': Colors.greenAccent[700]!,
        'title': 'Fetal Growth Charts',
        'description':
            'Visual tracking of your baby\'s development week by week'
      },
      {
        'icon': Icons.calendar_month,
        'color': Colors.teal,
        'title': 'Doctor Appointment Reminders',
        'description':
            'Schedule and get notified about upcoming prenatal checkups'
      },
      {
        'icon': Icons.edit,
        'color': Colors.amber[700]!,
        'title': 'Create Community Posts',
        'description':
            'Share your pregnancy experiences and insights with others'
      },
      // {
      //   'icon': Icons.show_chart,
      //   'color': Colors.purpleAccent,
      //   'title': 'Share Growth Charts',
      //   'description':
      //       'Easily share your baby\'s growth charts with family and friends'
      // },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF81C784), // Light Green
                  Color(0xFF388E3C), // Dark Green
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.stars,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Premium Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Features list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: premiumFeatures.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: feature['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          feature['icon'],
                          color: feature['color'],
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              feature['description'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
