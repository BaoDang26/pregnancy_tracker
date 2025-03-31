import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/util/num_utils.dart';

import '../../controllers/subscription_plan_guest_controller.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:intl/intl.dart';

class SubscriptionPlanGuestScreen
    extends GetView<SubscriptionPlanGuestController> {
  const SubscriptionPlanGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          );
        }

        return Container(
          color: const Color(0xFFF5F7FA),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  // Website-style header
                  _buildWebsiteHeader(),

                  // Main content with scrolling
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),

                            // Hero section
                            _buildHeroSection(),

                            const SizedBox(height: 50),

                            // Premium features section
                            _buildPremiumFeaturesSection(),

                            const SizedBox(height: 50),

                            // Pricing section title
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Choose Your Plan',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade800,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Select the plan that best fits your needs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Subscription plans section
                            controller.subscriptionPlanList.isEmpty
                                ? _buildEmptyState()
                                : _buildSubscriptionPlansGrid(),

                            const SizedBox(height: 50),

                            // FAQ section
                            _buildFAQSection(),

                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Website-style header with navigation
  Widget _buildWebsiteHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.card_membership,
                color: Colors.green[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Subscription Plans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // Hero section with headline and description
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[50]!,
            Colors.green[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enhance Your Pregnancy Journey',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Unlock premium features to track your baby\'s development, receive personalized advice, and connect with a supportive community of parents.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.star),
                      label: const Text('Explore Premium Features'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Image.network(
              'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185671/qke7fwc44wla2vqkzavt.jpg',
              fit: BoxFit.cover,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }

  // Premium features in a grid layout
  Widget _buildPremiumFeaturesSection() {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.favorite,
        'color': Colors.red[400]!,
        'title': 'Advanced Health Tracking',
        'description': 'Detailed monitoring of baby health metrics'
      },
      {
        'icon': Icons.monitor,
        'color': Colors.blue[400]!,
        'title': 'Fetal Growth Charts',
        'description':
            'Visual tracking of your baby\'s development week by week'
      },
      {
        'icon': Icons.calendar_month,
        'color': Colors.purple[400]!,
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
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Premium Features',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 40),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 2.5,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: feature['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      feature['icon'],
                      color: feature['color'],
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          feature['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          feature['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Subscription plans in a horizontal layout
  Widget _buildSubscriptionPlansGrid() {
    // Define the feature sets for each plan type
    final Map<String, List<String>> featuresByPlanType = {
      'basic': [
        'Basic health tracking',
        'Weekly tips and advice',
        'Basic pregnancy calendar',
        'View community posts',
        'Essential pregnancy information',
      ],
      'standard': [
        'Advanced health tracking',
        'Fetal growth charts',
        'Appointment reminders',
        'Create community posts',
        'Premium content access',
      ],
      'premium': [
        'All standard features',
        'Personalized pregnancy journey',
        'Detailed health analytics',
      ],
    };

    // Define color schemes for each plan
    final List<Map<String, Color>> colorSchemes = [
      {'bg': Colors.blue[50]!, 'accent': Colors.blue[700]!},
      {'bg': Colors.purple[50]!, 'accent': Colors.purple[700]!},
      {'bg': Colors.green[50]!, 'accent': Colors.green[700]!},
    ];

    // Xác định số lượng trang và số gói mỗi trang
    int totalPlans = controller.subscriptionPlanList.length;
    int plansPerPage = 3; // Hiển thị 3 gói mỗi trang
    int totalPages = (totalPlans / plansPerPage).ceil();

    // Sử dụng Obx để cập nhật UI khi currentPage thay đổi
    return Obx(() {
      // Tính toán các gói hiển thị trên trang hiện tại
      int startIndex = controller.currentPage.value * plansPerPage;
      int endIndex = startIndex + plansPerPage;
      if (endIndex > totalPlans) endIndex = totalPlans;

      int numPlans = endIndex - startIndex;

      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(numPlans, (index) {
              final planIndex = startIndex + index;
              final plan = controller.subscriptionPlanList[planIndex];
              final colorScheme = colorSchemes[planIndex % colorSchemes.length];

              // Determine which feature set to use based on plan name
              String planType = 'basic';
              final planName = plan.name?.toLowerCase() ?? '';
              if (planName.contains('premium')) {
                planType = 'premium';
              } else if (planName.contains('standard')) {
                planType = 'standard';
              }

              final features =
                  featuresByPlanType[planType] ?? featuresByPlanType['basic']!;
              final bool isPopular =
                  planType == 'standard'; // Mark the standard plan as popular

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: index > 0 ? 8 : 0,
                    right: index < numPlans - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isPopular
                          ? colorScheme['accent']!
                          : Colors.transparent,
                      width: isPopular ? 2 : 0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme['bg'],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: colorScheme['accent'],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'MOST POPULAR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            Text(
                              plan.name ?? 'Subscription Plan',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colorScheme['accent'],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${NumberFormat('#,###').format(plan.price)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme['accent'],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'VND',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme['accent'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'for ${plan.duration} days',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Plan content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.description ??
                                  'Access premium features and enhance your pregnancy journey.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Features list
                            ...features.map((feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: colorScheme['accent'],
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                            const SizedBox(height: 24),

                            // Choose plan button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => showDialog<void>(
                                  context: Get.context!,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Login Required'),
                                    content: const Text(
                                        'You must login to subscribe.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Get.toNamed(AppRoutes.login);
                                        },
                                        child: Text('Login',
                                            style: TextStyle(
                                                color: Colors.green[700])),
                                      ),
                                    ],
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPopular
                                      ? colorScheme['accent']
                                      : Colors.white,
                                  foregroundColor: isPopular
                                      ? Colors.white
                                      : colorScheme['accent'],
                                  elevation: isPopular ? 2 : 0,
                                  side: isPopular
                                      ? null
                                      : BorderSide(
                                          color: colorScheme['accent']!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Choose Plan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
              );
            }),
          ),

          // Thêm nút điều hướng nếu có nhiều hơn 3 gói
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nút điều hướng trái
                  IconButton(
                    onPressed: controller.currentPage.value > 0
                        ? () => controller.prevPage()
                        : null,
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.grey[700],
                    disabledColor: Colors.grey[300],
                  ),

                  // Hiển thị thông tin trang hiện tại
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Page ${controller.currentPage.value + 1} of $totalPages',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  // Nút điều hướng phải
                  IconButton(
                    onPressed: controller.currentPage.value < totalPages - 1
                        ? () => controller.nextPage()
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.grey[700],
                    disabledColor: Colors.grey[300],
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  // Empty state when no plans are available
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payments_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No subscription plans available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please check back later or contact our support team for assistance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: () => controller.getSubscriptionPlanGuestList(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FAQ section
  Widget _buildFAQSection() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'Can I subscribe to plans later?',
        'answer': 'Yes, you can upgrade your subscription plan at any time.'
      },
      {
        'question': 'How do I cancel my subscription?',
        'answer':
            'You can email us at support@pregnancytracker.com to cancel your subscription.'
      },
      {
        'question': 'Is my payment information secure?',
        'answer':
            'Yes, all payments are processed securely, and we don\'t store your payment details on our servers. We use industry-standard encryption to protect your information.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 30),
        ...faqs
            .map((faq) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(16),
                    title: Text(
                      faq['question']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['answer']!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
