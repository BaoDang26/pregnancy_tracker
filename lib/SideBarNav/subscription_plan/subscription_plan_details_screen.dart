import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pregnancy_tracker/util/num_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

import '../../controllers/subscription_plan_details_controller.dart';

class SubscriptionPlanDetailScreen
    extends GetView<SubscriptionPlanDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741174708/jowghg72mdvrrxnvfih2.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Loading subscription details...",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.green[700]),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Subscription Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 38,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F5E9),
                const Color(0xFFC8E6C9),
                Color(0xFFB2DFDB),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Hero Banner Section (Reduced height)
                      Container(
                        height: 180, // Reduced from 220
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF66BB6A),
                              Color(0xFF4CAF50),
                              Color(0xFF43A047),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Decorative elements
                            Positioned(
                              right: -20,
                              top: -20,
                              child: Opacity(
                                opacity: 0.2,
                                child: Container(
                                  width: 120, // Reduced from 150
                                  height: 120, // Reduced from 150
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: -30,
                              bottom: -30,
                              child: Opacity(
                                opacity: 0.2,
                                child: Container(
                                  width: 100, // Reduced from 120
                                  height: 100, // Reduced from 120
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),

                            // Plan details
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15), // Reduced padding
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(
                                            8), // Reduced from 10
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.star,
                                          size: 24, // Reduced from 30
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 10), // Reduced from 15
                                      Expanded(
                                        child: Text(
                                          '${controller.subscriptionPlan.value.name}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28, // Reduced from 32
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15), // Reduced from 20
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10), // Reduced padding
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${controller.subscriptionPlan.value.price?.round().formatWithThousandSeparator()} VND',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26, // Reduced from 30
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${controller.subscriptionPlan.value.duration} days",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
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

                      // Description Card - Minimal padding, more compact layout
                      Padding(
                        padding: const EdgeInsets.all(15), // Reduced from 20
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Plan Description
                              Container(
                                padding:
                                    const EdgeInsets.all(20), // Reduced from 25
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: Colors.green[700],
                                          size: 22, // Reduced from 24
                                        ),
                                        const SizedBox(
                                            width: 8), // Reduced from 10
                                        Text(
                                          "Plan Description",
                                          style: TextStyle(
                                            fontSize: 18, // Reduced from 20
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 12), // Reduced from 15
                                    Container(
                                      padding: const EdgeInsets.all(
                                          12), // Reduced from 15
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        '${controller.subscriptionPlan.value.description}',
                                        style: TextStyle(
                                          fontSize: 15, // Reduced from 16
                                          color: Colors.grey[800],
                                          height: 1.4, // Reduced from 1.5
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 20), // Reduced from 30

                                    // Plan Benefits
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.green[700],
                                          size: 22, // Reduced from 24
                                        ),
                                        const SizedBox(
                                            width: 8), // Reduced from 10
                                        Text(
                                          "Plan Benefits",
                                          style: TextStyle(
                                            fontSize: 18, // Reduced from 20
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 12), // Reduced from 15

                                    // Feature list - more compact
                                    _buildFeatureItem(
                                        icon: Icons.check_circle,
                                        text: "Access to all premium features"),
                                    // _buildFeatureItem(
                                    //     icon: Icons.check_circle,
                                    //     text: "No advertisements"),
                                    _buildFeatureItem(
                                        icon: Icons.check_circle,
                                        text: "Priority support"),
                                    // _buildFeatureItem(
                                    //     icon: Icons.check_circle,
                                    //     text: "Offline access to saved content"),

                                    const SizedBox(
                                        height: 20), // Reduced from 30

                                    // Payment Method
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.payments_outlined,
                                          color: Colors.green[700],
                                          size: 22, // Reduced from 24
                                        ),
                                        const SizedBox(
                                            width: 8), // Reduced from 10
                                        Text(
                                          "Payment Method",
                                          style: TextStyle(
                                            fontSize: 18, // Reduced from 20
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 12), // Reduced from 15
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 12), // Reduced padding
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.grey[50]!
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.blue[700]!,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Logo container
                                          Container(
                                            padding: const EdgeInsets.all(
                                                8), // Reduced from 10
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Colors.blue[50]!
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // Reduced from 10
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Image.network(
                                              'https://res.cloudinary.com/dlipvbdwi/image/upload/v1740010783/VNPay.png',
                                              height: 35, // Reduced from 40
                                              width: 35, // Reduced from 40
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(
                                              width: 12), // Reduced from 15
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'VNPay',
                                                style: TextStyle(
                                                  fontSize:
                                                      15, // Reduced from 16
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[800],
                                                ),
                                              ),
                                              Text(
                                                'Fast and secure payment',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green[600],
                                            size: 20, // Reduced from 24
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Subscribe Button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15), // Reduced padding
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Amount:",
                                          style: TextStyle(
                                            fontSize: 15, // Reduced from 16
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        Text(
                                          "${controller.subscriptionPlan.value.price?.round().formatWithThousandSeparator()} VND",
                                          style: TextStyle(
                                            fontSize: 17, // Reduced from 18
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 15), // Reduced from 20
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50, // Reduced from 55
                                      child: ElevatedButton(
                                        onPressed: () {
                                          controller.subscribesPlan();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[600],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                                width: 8), // Reduced from 10
                                            Text(
                                              "Subscribe Now",
                                              style: TextStyle(
                                                fontSize: 17, // Reduced from 18
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 12), // Reduced from 15
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          size: 12, // Reduced from 14
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Secure Transaction",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Add padding at the bottom to ensure everything is visible
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Reduced from 12.0
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green[600],
            size: 18, // Reduced from 20
          ),
          const SizedBox(width: 8), // Reduced from 10
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
