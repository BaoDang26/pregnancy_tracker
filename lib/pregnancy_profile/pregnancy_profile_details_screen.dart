import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/pregnancy_profile_details_controller.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';
import '../widgets/custom_elevated_button.dart';

class PregnancyProfileDetailsScreen
    extends GetView<PregnancyProfileDetailsController> {
  const PregnancyProfileDetailsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF5FF),
              Color(0xFFE8F5E9),
              Color(0xFFE1F0F5),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildHeroSection(context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileDetailsSection(),
                      SizedBox(height: 24),
                      _buildActionButtons(),
                      SizedBox(height: 24),
                      _buildResourcesSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8BC34A),
            Color(0xFF66BB6A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'PREGNANCY PROFILE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Obx(() => Text(
                    'Week ${controller.pregnancyProfileModel.value.pregnancyWeek} - ${controller.pregnancyProfileModel.value.nickName ?? "My Baby"}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          height: 320,
          width: double.infinity,
          child: ClipRRect(
            child: Image.network(
              'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/pregnancy_placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Gradient overlay
        Container(
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Text overlay
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Pregnancy Journey',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome to pregnancy! This is the start of an incredible journey with information, tracking tools, and support every step of the way.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsSection() {
    return Obx(() {
      final profile = controller.pregnancyProfileModel.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pregnant_woman_rounded,
                    color: Colors.green[700],
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Profile Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),

            Divider(
                height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),

            // Nickname
            _buildProfileDetailItem(
              icon: Icons.person,
              iconColor: Colors.blue[700]!,
              iconBgColor: Colors.blue[50]!,
              title: 'Baby\'s nickname',
              value: profile.nickName ?? 'Not set',
            ),

            // Due Date
            _buildProfileDetailItem(
              icon: Icons.event,
              iconColor: Colors.pink[700]!,
              iconBgColor: Colors.pink[50]!,
              title: 'Due Date',
              value: profile.dueDate?.format() ?? 'Not set',
            ),

            // Last Period Date
            _buildProfileDetailItem(
              icon: Icons.calendar_today,
              iconColor: Colors.purple[700]!,
              iconBgColor: Colors.purple[50]!,
              title: 'Last Period Date',
              value: profile.lastPeriodDate?.format() ?? 'Not set',
            ),

            // Pregnancy Week
            _buildProfileDetailItem(
              icon: Icons.timeline,
              iconColor: Colors.amber[700]!,
              iconBgColor: Colors.amber[50]!,
              title: 'Pregnancy Week',
              value: '${profile.pregnancyWeek} weeks',
              showProgress: true,
              progressValue: (profile.pregnancyWeek ?? 0) /
                  40, // Assuming 40 weeks full term
            ),

            // Notes
            _buildProfileDetailItem(
              icon: Icons.note_alt,
              iconColor: Colors.teal[700]!,
              iconBgColor: Colors.teal[50]!,
              title: 'Notes',
              value: profile.notes ?? 'No notes added',
              isLongText: true,
            ),

            SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _buildProfileDetailItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    bool isLongText = false,
    bool showProgress = false,
    double progressValue = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          isLongText
              ? Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                )
              : Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                ),
          if (showProgress)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${(progressValue * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 10,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                    ),
                  ),
                ],
              ),
            ),
          if (!isLongText && !showProgress) SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.analytics,
              text: 'Fetal Growth Measurement',
              color: Colors.indigo[600]!,
              onPressed: () {
                controller.goToFetalGrowthMeasurement();
              },
            ),
            SizedBox(width: 20),
            _buildActionButton(
              icon: Icons.event_note,
              text: 'Schedule',
              color: Colors.green[600]!,
              onPressed: () {
                controller.goToSchedule();
              },
            ),
          ],
        ),
        // SizedBox(height: 16),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _buildActionButton(
        //       icon: Icons.edit_calendar,
        //       text: 'Modify',
        //       color: Colors.amber[700]!,
        //       onPressed: () {
        //         // controller.goToEditProfile();
        //       },
        //     ),
        //     SizedBox(width: 20),
        //     _buildActionButton(
        //       icon: Icons.info_outline,
        //       text: 'Tips',
        //       color: Colors.pink[600]!,
        //       onPressed: () {
        //         // controller.goToPregnancyTips();
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 220,
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.blue[700],
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Pregnancy Resources',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),

          // Resource items
          _buildResourceItem(
            icon: Icons.calendar_month,
            title: 'Weekly Development',
            description: 'Track your baby\'s growth week by week',
          ),

          // _buildResourceItem(
          //   icon: Icons.restaurant_menu,
          //   title: 'Nutrition Guide',
          //   description: 'Best foods for pregnancy and what to avoid',
          // ),

          // _buildResourceItem(
          //   icon: Icons.spa,
          //   title: 'Self-Care Tips',
          //   description: 'Tips for staying comfortable during pregnancy',
          // ),

          // More resources button
          Padding(
            padding: EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                _launchURL('https://www.babycenter.com/pregnancy');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[700],
                side: BorderSide(color: Colors.blue[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View More Resources',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return InkWell(
      onTap: () {
        _launchURL(
            'https://www.vinmec.com/vie/bai-viet/bang-can-nang-va-chieu-dai-thai-nhi-theo-tieu-chuan-cua-who-vi');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.blue[700],
                size: 24,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
