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
        decoration: const BoxDecoration(
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
        // Website-like responsive layout with centered content
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1500),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWebsiteHeader(),
                    _buildWebHeroSection(context),
                    // Content with fixed max-width
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left column - Profile Details (2/3 width)
                          Expanded(
                            flex: 2,
                            child: _buildProfileDetailsSection(),
                          ),
                          const SizedBox(width: 24),
                          // Right column - Action buttons and Resources (1/3 width)
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildActionButtonsPanel(),
                                const SizedBox(height: 24),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Text(
                                    '🪖 Notice: The Fetal Growth Measurement is available starting from 8 weeks of pregnancy. Please consider carefully if you want to subscribe to the service.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildResourcesSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Website-style header with navigation
  Widget _buildWebsiteHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          TextButton.icon(
            icon: Icon(Icons.home_outlined),
            label: Text('Home'),
            onPressed: () => Get.offAllNamed(AppRoutes.sidebarnar, arguments: {
              'selectedIndex': 2,
            }),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green[700],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.favorite,
            color: Color(0xFF66BB6A),
            size: 24,
          ),
          const SizedBox(width: 10),
          Obx(() => Text(
                'Pregnancy Profile: ${controller.pregnancyProfileModel.value.nickName ?? "My Baby"} - Week ${controller.pregnancyProfileModel.value.pregnancyWeek}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              )),
          Spacer(),
        ],
      ),
    );
  }

  // Banner-style hero section
  Widget _buildWebHeroSection(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image
          Image.network(
            'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/pregnancy_placeholder.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          ),

          // Gradient overlay
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Text overlay
          Positioned(
            top: 50,
            left: 50,
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Pregnancy Journey',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome to pregnancy! This is the start of an incredible journey with information, tracking tools, and support every step of the way.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsSection() {
    return Obx(() {
      final profile = controller.pregnancyProfileModel.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pregnant_woman_rounded,
                    color: Colors.green[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
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

            // Two column layout for profile details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // First row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1
                      Expanded(
                        child: _buildDetailColumn(
                          items: [
                            DetailItem(
                              icon: Icons.person,
                              iconColor: Colors.blue[700]!,
                              iconBgColor: Colors.blue[50]!,
                              title: 'Baby\'s nickname',
                              value: profile.nickName ?? 'Not set',
                            ),
                            DetailItem(
                              icon: Icons.timeline,
                              iconColor: Colors.amber[700]!,
                              iconBgColor: Colors.amber[50]!,
                              title: 'Pregnancy Week',
                              value: '${profile.pregnancyWeek} weeks',
                              showProgress: true,
                              progressValue: (profile.pregnancyWeek ?? 0) / 40,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Column 2
                      Expanded(
                        child: _buildDetailColumn(
                          items: [
                            DetailItem(
                              icon: Icons.calendar_today,
                              iconColor: Colors.purple[700]!,
                              iconBgColor: Colors.purple[50]!,
                              title: 'Last Period Date',
                              value:
                                  profile.lastPeriodDate?.format() ?? 'Not set',
                            ),
                            DetailItem(
                              icon: Icons.event,
                              iconColor: Colors.pink[700]!,
                              iconBgColor: Colors.pink[50]!,
                              title: 'Due Date',
                              value: profile.dueDate?.format() ?? 'Not set',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Notes section - full width
                  _buildNotesSection(profile.notes ?? 'No notes added'),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDetailColumn({required List<DetailItem> items}) {
    return Column(
      children: items.map((item) => _buildDetailItemWeb(item)).toList(),
    );
  }

  Widget _buildDetailItemWeb(DetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              item.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          if (item.showProgress)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
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
                        '${(item.progressValue * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: item.progressValue,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.note_alt,
                color: Colors.teal[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Notes',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            notes,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.dashboard_customize,
                  color: Colors.indigo[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Available Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildWebActionButton(
                  icon: Icons.analytics,
                  text: 'Fetal Growth Measurement',
                  color: Colors.indigo[600]!,
                  onPressed: () {
                    controller.goToFetalGrowthMeasurement();
                  },
                ),
                const SizedBox(height: 12),
                _buildWebActionButton(
                  icon: Icons.event_note,
                  text: 'Schedule',
                  color: Colors.green[600]!,
                  onPressed: () {
                    controller.goToSchedule();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Pregnancy Resources',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),

          // Resource item
          _buildResourceItem(
            icon: Icons.calendar_month,
            title: 'Weekly Development',
            description: 'Track your baby\'s growth week by week',
          ),

          // More resources button
          Padding(
            padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View More Resources',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.blue[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for detail items
class DetailItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String value;
  final bool showProgress;
  final double progressValue;

  DetailItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.value,
    this.showProgress = false,
    this.progressValue = 0.0,
  });
}
