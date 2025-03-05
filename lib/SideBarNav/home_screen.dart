import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/util/num_utils.dart';
import 'package:pregnancy_tracker/widgets/custom_card_subscription_plan_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/home_screen_controller.dart';
import '../login/login_screen.dart';
import '../widgets/custom_card_blog_widget.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselController _carouselController = CarouselController();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE8F5E9), // Xanh lá nhạt nhất
                    Color(0xFFC8E6C9), // Xanh lá nhạt
                    Color(0xFFB2DFDB), // Xanh ngọc nhạt
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section with Gradient Overlay
                    Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF81C784), // Xanh lá đậm hơn
                            Color(0xFF4CAF50).withOpacity(0.8), // Xanh lá chính
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background Pattern
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.1,
                              child: Image.network(
                                'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741174708/jowghg72mdvrrxnvfih2.png',
                                repeat: ImageRepeat.repeat,
                              ),
                            ),
                          ),

                          // Header Content
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Pregnancy Journey',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Track, monitor, and celebrate every moment',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Image Carousel Section with Rounded Corners
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  color: Colors.green[700],
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Pregnancy Moments',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CarouselSlider(
                                    carouselController: _carouselController,
                                    options: CarouselOptions(
                                      height: 500.0,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 4),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.easeInOut,
                                      enlargeCenterPage: true,
                                      viewportFraction: 1.0,
                                    ),
                                    items: [
                                      'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185671/qke7fwc44wla2vqkzavt.jpg',
                                      'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
                                      'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185766/pk5pftmbojduyokcyx9z.jpg',
                                    ].map((imageUrl) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.5),
                                              ],
                                              stops: [0.6, 1.0],
                                            ),
                                          ),
                                          alignment: Alignment.bottomCenter,
                                          padding: EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            'Every stage is precious',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              // Navigation Arrows
                              Positioned(
                                left: 30,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.arrow_back_ios_new,
                                        color: Colors.green[700]),
                                    onPressed: () =>
                                        _carouselController.previousPage(),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 30,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.arrow_forward_ios,
                                        color: Colors.green[700]),
                                    onPressed: () =>
                                        _carouselController.nextPage(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Membership Packages Section
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.card_membership,
                                color: Colors.green[700],
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Membership Packages',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Membership Cards with Horizontal Scroll
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.subscriptionPlanList.length,
                              itemBuilder: (context, index) {
                                final plan =
                                    controller.subscriptionPlanList[index];
                                return _buildMembershipCard(
                                  name: plan.name ?? 'Subscription',
                                  price: plan.price ?? 0,
                                  duration: plan.duration ?? 30,
                                  description:
                                      plan.description ?? 'No description',
                                  color: Colors.blue[100]!,
                                  iconColor: Colors.blue[700]!,
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // FAQ Section
                    Container(
                      padding: EdgeInsets.all(20),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.question_answer,
                                color: Colors.green[700],
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Frequently Asked Questions',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildFaqItem(
                            question:
                                'What is the best time to start tracking my pregnancy?',
                            answer:
                                'It is best to start tracking your pregnancy as soon as you find out you are pregnant. This helps in monitoring your health and the baby\'s development from the earliest stages.',
                          ),
                          _buildFaqItem(
                            question:
                                'How often should I visit my doctor during pregnancy?',
                            answer:
                                'For a typical pregnancy, you might visit your doctor once a month for the first 28 weeks, then every two weeks until 36 weeks, and then weekly until delivery. High-risk pregnancies may require more frequent visits.',
                          ),
                          _buildFaqItem(
                            question:
                                'Is it normal to have mood swings during pregnancy?',
                            answer:
                                'Yes, mood swings are completely normal during pregnancy due to hormonal changes. If you feel your mood swings are severe or concerning, it\'s always good to discuss with your healthcare provider.',
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF81C784).withOpacity(0.9),
                            Color(0xFF4CAF50),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Your Pregnancy Companion',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Track your pregnancy journey with our app',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFooterIcon(Icons.help_outline),
                              SizedBox(width: 20),
                              _buildFooterIcon(Icons.settings),
                              SizedBox(width: 20),
                              _buildFooterIcon(Icons.contact_support),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Logout button positioned in the top right corner
            Positioned(
              top: 40, // Adjust this value as needed for proper positioning
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // Handle logout
                      Get.find<HomeScreenController>().logout();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.green[700],
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper method to build Quick Link buttons
  Widget _buildQuickLink(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.green[700],
              size: 28,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build membership cards
  Widget _buildMembershipCard({
    required String name,
    required int price,
    required int duration,
    required String description,
    required Color color,
    required Color iconColor,
    required int index,
  }) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: iconColor,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "${price.formatWithThousandSeparator()} VND",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${duration} days',
            style: TextStyle(
              fontSize: 14,
              color: iconColor,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handler for subscription
              controller.goToSubscriptionPlanDetail(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(double.infinity, 36),
            ),
            child: Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  // Helper method to build FAQ items
  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        expandedAlignment: Alignment.topLeft,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build footer icons
  Widget _buildFooterIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
