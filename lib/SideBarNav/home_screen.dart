import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/home_screen_controller.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselController _carouselController = CarouselController();
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          decoration: BoxDecoration(
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
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading your journey...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
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
                    Color(0xFFFFF8E1), // Vàng nhẹ ấm áp
                    Color(0xFFE8F5E9), // Xanh lá nhạt
                    Color(0xFFE1F5FE), // Xanh dương nhạt
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section with Welcome Message
                    Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEF9A9A), // Hồng nhạt
                            Color(0xFFFFCC80), // Cam nhạt
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.child_friendly_outlined,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Mommy\'s Journey',
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
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Every step of your beautiful journey matters',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ElevatedButton.icon(
                                    //   onPressed: () =>
                                    //       Get.toNamed(AppRoutes.login),
                                    //   style: ElevatedButton.styleFrom(
                                    //     backgroundColor: Colors.white,
                                    //     foregroundColor: Colors.pink[400],
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 20, vertical: 12),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(30),
                                    //     ),
                                    //   ),
                                    //   icon: Icon(Icons.login),
                                    //   label: Text(
                                    //     'Sign In',
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(width: 12),
                                    // OutlinedButton.icon(
                                    //   onPressed: () =>
                                    //       Get.toNamed(AppRoutes.register),
                                    //   style: OutlinedButton.styleFrom(
                                    //     foregroundColor: Colors.white,
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 20, vertical: 12),
                                    //     side: BorderSide(
                                    //         color: Colors.white, width: 2),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(30),
                                    //     ),
                                    //   ),
                                    //   icon: Icon(Icons.person_add),
                                    //   label: Text(
                                    //     'Register',
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // About This App Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.purple[400],
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 14),
                              Text(
                                'About Our App',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Pregnancy Tracker is your personal companion throughout your pregnancy journey. We provide comprehensive tools to monitor your baby\'s growth, track your health, and prepare for the big day.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFeatureItem(
                                  icon: Icons.calendar_today,
                                  title: 'Weekly Tracking',
                                  description:
                                      'Follow your baby\'s development week by week with detailed insights',
                                  color: Colors.blue[400]!,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildFeatureItem(
                                  icon: Icons.monitor_heart_outlined,
                                  title: 'Health Monitoring',
                                  description:
                                      'Track important health metrics for your baby',
                                  color: Colors.red[400]!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: _buildFeatureItem(
                          //         icon: Icons.food_bank_outlined,
                          //         title: 'Nutrition Guide',
                          //         description:
                          //             'Get personalized nutrition recommendations for a healthy pregnancy',
                          //         color: Colors.green[400]!,
                          //       ),
                          //     ),
                          //     SizedBox(width: 16),
                          //     Expanded(
                          //       child: _buildFeatureItem(
                          //         icon: Icons.psychology_outlined,
                          //         title: 'Expert Advice',
                          //         description:
                          //             'Access professional advice for common pregnancy questions',
                          //         color: Colors.amber[700]!,
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[50],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.photo_library,
                                    color: Colors.pink[400],
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Beautiful Moments',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CarouselSlider(
                                    carouselController: _carouselController,
                                    options: CarouselOptions(
                                      height: 600.0,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 5),
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
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              'Capturing precious moments',
                                              style: TextStyle(
                                                color: Colors.pink[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.arrow_back_ios_new,
                                        color: Colors.pink[400]),
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
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.arrow_forward_ios,
                                        color: Colors.pink[400]),
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

                    SizedBox(height: 24),

                    // How It Works Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.teal[50],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.tour,
                                  color: Colors.teal[400],
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 14),
                              Text(
                                'How It Works',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildHowItWorksStep(
                            number: '1',
                            title: 'Sign Up',
                            description:
                                'Create your account to begin tracking your pregnancy journey',
                            color: Colors.teal[400]!,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.teal[100],
                          ),
                          _buildHowItWorksStep(
                            number: '2',
                            title: 'Enter Your Pregnancy Data',
                            description:
                                'Input your due date or first day of last period to get personalized tracking',
                            color: Colors.teal[400]!,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.teal[100],
                          ),
                          _buildHowItWorksStep(
                            number: '3',
                            title: 'Track Your Journey',
                            description:
                                'Monitor your baby\'s growth, manage appointments, and get weekly updates',
                            color: Colors.teal[400]!,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.teal[100],
                          ),
                          _buildHowItWorksStep(
                            number: '4',
                            title: 'Stay Informed',
                            description:
                                'Access articles, tips, and expert advice for a healthy pregnancy',
                            color: Colors.teal[400]!,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // FAQ Section
                    Container(
                      padding: EdgeInsets.all(24),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.question_answer,
                                  color: Colors.amber[700],
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 14),
                              Text(
                                'Frequently Asked Questions',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildFaqItem(
                            question:
                                'How can this app help me during pregnancy?',
                            answer:
                                'Our app provides week-by-week tracking of your baby\'s development, health monitoring tools, nutrition guides, appointment reminders, and personalized advice to support you throughout your pregnancy journey.',
                            color: Colors.amber[700]!,
                          ),
                          _buildFaqItem(
                            question: 'Is my personal health data secure?',
                            answer:
                                'Yes, we take data security very seriously. All your personal health information is encrypted and stored securely. We never share your data with third parties without your explicit consent.',
                            color: Colors.amber[700]!,
                          ),
                          _buildFaqItem(
                            question:
                                'How accurate are the pregnancy calculators?',
                            answer:
                                'Our pregnancy calculators provide estimates based on the information you provide and medical standards. While they are generally reliable, they should be used as a guide. Always consult with your healthcare provider for medical decisions.',
                            color: Colors.amber[700]!,
                          ),
                          _buildFaqItem(
                            question:
                                'Can I use the app after my baby is born?',
                            answer:
                                'Absolutely! Our app includes features for tracking your baby\'s growth and development after birth, as well as postpartum recovery resources for new mothers.',
                            color: Colors.amber[700]!,
                          ),
                        ],
                      ),
                    ),

                    // Testimonials Section
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.format_quote,
                                  color: Colors.purple[400],
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 14),
                              Text(
                                'What Mothers Say',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildTestimonial(
                            quote:
                                "This app has been my constant companion during pregnancy. The weekly updates are so informative, and I love tracking my baby's growth!",
                            name: "Sarah, 28",
                            imagUrl:
                                "https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg",
                          ),
                          SizedBox(height: 16),
                          _buildTestimonial(
                            quote:
                                "As a first-time mom, I had so many questions. The expert advice section answered almost everything I needed to know. Highly recommend!",
                            name: "Emily, 32",
                            imagUrl:
                                "https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185766/pk5pftmbojduyokcyx9z.jpg",
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFCCBC), // Cam nhạt
                            Color(0xFFF8BBD0), // Hồng nhạt
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
                              Icon(Icons.favorite, color: Colors.red[300]),
                              SizedBox(width: 8),
                              Text(
                                'Your Pregnancy Companion',
                                style: TextStyle(
                                  color: Colors.pink[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.favorite, color: Colors.red[300]),
                            ],
                          ),
                          // SizedBox(height: 20),
                          // Text(
                          //   'Start your journey today by creating an account',
                          //   style: TextStyle(
                          //     color: Colors.pink[800],
                          //     fontSize: 16,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          // SizedBox(height: 24),
                          // ElevatedButton.icon(
                          //   onPressed: () => Get.toNamed(AppRoutes.register),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.white,
                          //     foregroundColor: Colors.pink[500],
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 30, vertical: 15),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   icon: Icon(Icons.app_registration),
                          //   label: Text(
                          //     'Join Us Now',
                          //     style: TextStyle(
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFooterIcon(Icons.security, "Privacy"),
                              SizedBox(width: 20),
                              _buildFooterIcon(Icons.help_outline, "Help"),
                              SizedBox(width: 20),
                              _buildFooterIcon(
                                  Icons.contact_support, "Contact"),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            '© 2024 Pregnancy Tracker App. All rights reserved.',
                            style: TextStyle(
                              color: Colors.pink[800],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper method to build feature item
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Helper method to build How It Works step
  Widget _buildHowItWorksStep({
    required String number,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build FAQ items
  Widget _buildFaqItem({
    required String question,
    required String answer,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.8),
          ),
        ),
        expandedAlignment: Alignment.topLeft,
        childrenPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: <Widget>[
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build testimonial
  Widget _buildTestimonial({
    required String quote,
    required String name,
    required String imagUrl,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          Icon(
            Icons.format_quote,
            color: Colors.purple[300],
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            quote,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imagUrl),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build footer icons
  Widget _buildFooterIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.pink[700],
            size: 24,
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.pink[800],
          ),
        ),
      ],
    );
  }
}
