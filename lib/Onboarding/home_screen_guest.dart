import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/home_screen_guest_controller.dart';

class HomeScreenGuest extends GetView<HomeScreenGuestController> {
  const HomeScreenGuest({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselController _carouselController = CarouselController();
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.pink[400]!),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading your journey...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.pink[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Icon(Icons.child_friendly_outlined, color: Colors.pink[400]),
              const SizedBox(width: 12),
              Text(
                'Mommy\'s Journey',
                style: TextStyle(
                  color: Colors.pink[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => Get.toNamed(AppRoutes.register),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.pink[400],
                side: BorderSide(color: Colors.pink[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Sign Up'),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                height: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFEF9A9A),
                      Color(0xFFFFCC80),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Left side content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 100.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Your Pregnancy\nJourney Starts Here',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 400,
                              child: Text(
                                'Every step of your beautiful journey matters. Track your baby\'s growth, monitor your health, and prepare for the big day.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => Get.toNamed(AppRoutes.login),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.pink[700],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right side image
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Image.network(
                          'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185671/qke7fwc44wla2vqkzavt.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // About Section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.purple[400],
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'About Our App',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Pregnancy Tracker is your personal companion throughout your pregnancy journey. We provide comprehensive tools to monitor your baby\'s growth, track your health, and prepare for the big day.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildFeatureItem(
                            icon: Icons.monitor_heart_outlined,
                            title: 'Health Monitoring',
                            description:
                                'Track important health metrics for your baby',
                            color: Colors.red[400]!,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildFeatureItem(
                            icon: Icons.psychology_outlined,
                            title: 'Expert Advice',
                            description:
                                'Access professional advice for common pregnancy questions',
                            color: Colors.amber[700]!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Beautiful Moments Section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
                color: Colors.grey[50],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Colors.pink[400],
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Beautiful Moments',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                height: 500.0,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.easeInOut,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                              ),
                              items: [
                                'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185671/qke7fwc44wla2vqkzavt.jpg',
                                'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
                                'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185766/pk5pftmbojduyokcyx9z.jpg',
                              ].map((imageUrl) {
                                return Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Capture Every Precious Moment',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[700],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Your pregnancy journey is filled with beautiful moments worth remembering. Our app helps you post and cherish these special times in your life by creating a beautiful timeline.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  _buildImageIconButton(
                                    'Week 12',
                                    'First trimester milestones',
                                    Colors.pink[100]!,
                                    Colors.pink[700]!,
                                  ),
                                  const SizedBox(width: 15),
                                  _buildImageIconButton(
                                    'Week 24',
                                    'Second trimester journey',
                                    Colors.purple[100]!,
                                    Colors.purple[700]!,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  _buildImageIconButton(
                                    'Week 36',
                                    'Preparing for arrival',
                                    Colors.blue[100]!,
                                    Colors.blue[700]!,
                                  ),
                                  const SizedBox(width: 15),
                                  _buildImageIconButton(
                                    'The Big Day',
                                    'Welcoming your baby',
                                    Colors.green[100]!,
                                    Colors.green[700]!,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // How It Works Section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tour,
                          color: Colors.teal[400],
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHowItWorksStepWeb(
                            number: '1',
                            title: 'Register',
                            description:
                                'Create your account to begin tracking your pregnancy journey',
                            color: Colors.teal[400]!,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildHowItWorksStepWeb(
                            number: '2',
                            title: 'Enter Your Data',
                            description:
                                'Input your due date or first day of last period to get personalized tracking',
                            color: Colors.teal[400]!,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildHowItWorksStepWeb(
                            number: '3',
                            title: 'Track Your Journey',
                            description:
                                'Monitor your baby\'s growth, manage appointments, and get weekly updates',
                            color: Colors.teal[400]!,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildHowItWorksStepWeb(
                            number: '4',
                            title: 'Stay Informed',
                            description:
                                'Access articles, tips, and expert advice for a healthy pregnancy',
                            color: Colors.teal[400]!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // FAQ Section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
                color: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.question_answer,
                          color: Colors.amber[700],
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildFaqItemWeb(
                                question:
                                    'How can this app help me during pregnancy?',
                                answer:
                                    'Our app provides week-by-week tracking of your baby\'s development, health monitoring tools, nutrition guides, appointment reminders, and personalized advice to support you throughout your pregnancy journey.',
                                color: Colors.amber[700]!,
                              ),
                              const SizedBox(height: 20),
                              _buildFaqItemWeb(
                                question: 'Is my personal health data secure?',
                                answer:
                                    'Yes, we take data security very seriously. All your personal health information is encrypted and stored securely. We never share your data with third parties without your explicit consent.',
                                color: Colors.amber[700]!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            children: [
                              _buildFaqItemWeb(
                                question:
                                    'How accurate are the pregnancy calculators?',
                                answer:
                                    'Our pregnancy calculators provide estimates based on the information you provide and medical standards. While they are generally reliable, they should be used as a guide. Always consult with your healthcare provider for medical decisions.',
                                color: Colors.amber[700]!,
                              ),
                              const SizedBox(height: 20),
                              _buildFaqItemWeb(
                                question:
                                    'Can I use the app after my baby is born?',
                                answer:
                                    'Absolutely! Our app includes features for tracking your baby\'s growth and development after birth, as well as postpartum recovery resources for new mothers.',
                                color: Colors.amber[700]!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Testimonials
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 100),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: Colors.purple[400],
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'What Mothers Say',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTestimonialWeb(
                            quote:
                                "This app has been my constant companion during pregnancy. The weekly updates are so informative, and I love tracking my baby's growth!",
                            name: "Sarah, 28",
                            imagUrl:
                                "https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg",
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildTestimonialWeb(
                            quote:
                                "As a first-time mom, I had so many questions. The expert advice section answered almost everything I needed to know. Highly recommend!",
                            name: "Emily, 32",
                            imagUrl:
                                "https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185766/pk5pftmbojduyokcyx9z.jpg",
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildTestimonialWeb(
                            quote:
                                "The community section is amazing. Being able to connect with other moms going through the same thing has been so helpful with my anxiety.",
                            name: "Jessica, 30",
                            imagUrl:
                                "https://res.cloudinary.com/dlipvbdwi/image/upload/v1741185671/qke7fwc44wla2vqkzavt.jpg",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Call to Action
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 100),
                color: Color(0xFFFFF8E1),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ready to Start Your Journey?',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[700],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Join thousands of moms who have transformed their pregnancy experience with our app. Sign up today to access all features and start tracking your amazing journey.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => Get.toNamed(AppRoutes.register),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink[400],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () => Get.toNamed(AppRoutes.login),
                              child: Text(
                                'Already have an account? Sign In',
                                style: TextStyle(
                                  color: Colors.pink[700],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
                color: Colors.grey[900],
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo and description
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.child_friendly_outlined,
                                    color: Colors.pink[300],
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Mommy\'s Journey',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Your trusted companion throughout the beautiful journey of pregnancy. We provide tools and resources to make this special time even more memorable.',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _buildSocialIcon(
                                      Icons.facebook, Colors.blue[400]!),
                                  const SizedBox(width: 12),
                                  _buildSocialIcon(
                                      Icons.telegram, Colors.blue[300]!),
                                  const SizedBox(width: 12),
                                  _buildSocialIcon(
                                      Icons.phone, Colors.green[400]!),
                                  const SizedBox(width: 12),
                                  _buildSocialIcon(Icons.alternate_email,
                                      Colors.orange[400]!),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Links columns
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pages',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildFooterLink('Home'),
                              _buildFooterLink('About Us'),
                              _buildFooterLink('Features'),
                              _buildFooterLink('Blog'),
                              _buildFooterLink('Contact'),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Features',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildFooterLink('Weekly Tracking'),
                              _buildFooterLink('Health Monitoring'),
                              _buildFooterLink('Nutrition Guide'),
                              _buildFooterLink('Community'),
                              _buildFooterLink('Expert Advice'),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.grey[400], size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '123 Hung Vuong Street, Hanoi, Vietnam',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.email,
                                      color: Colors.grey[400], size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'support@pregnancytracker.com',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.phone,
                                      color: Colors.grey[400], size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+84943 292 293',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      height: 1,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '© 2024 Mommy\'s Journey. All rights reserved.',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                        Row(
                          children: [
                            _buildFooterLink('Privacy Policy'),
                            const SizedBox(width: 20),
                            _buildFooterLink('Terms of Service'),
                            const SizedBox(width: 20),
                            _buildFooterLink('Cookie Policy'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for image icon buttons
  Widget _buildImageIconButton(
    String title,
    String subtitle,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for how it works step (web version)
  Widget _buildHowItWorksStepWeb({
    required String number,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper method for FAQ items (web version)
  Widget _buildFaqItemWeb({
    required String question,
    required String answer,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for testimonials (web version)
  Widget _buildTestimonialWeb({
    required String quote,
    required String name,
    required String imagUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.purple.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            color: Colors.purple[300],
            size: 40,
          ),
          const SizedBox(height: 20),
          Text(
            quote,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imagUrl),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
        ],
      ),
    );
  }

  // Social icon for footer
  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  // Footer link
  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
