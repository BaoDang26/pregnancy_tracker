import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nhập thư viện intl
import 'package:url_launcher/url_launcher.dart';

import '../controllers/pregnancy_profile_controller.dart';
import '../util/app_export.dart';
import '../widgets/pregnancy_profile_card.dart';

class PregnancyProfileScreen extends GetView<PregnancyProfileController> {
  const PregnancyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Color(0xFFB2DFDB),
              ],
            ),
          ),
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
                            const SizedBox(height: 24),

                            // Summary cards section
                            _buildSummarySection(),

                            const SizedBox(height: 32),

                            // Info and action section
                            _buildInfoAndActionSection(),

                            const SizedBox(height: 32),

                            // Profile section header
                            _buildSectionHeader(
                              "Your Pregnancy Profiles",
                              "Manage all your pregnancy journeys in one place",
                              controller.pregnancyProfileList.isNotEmpty &&
                                  controller
                                          .pregnancyProfileList.last.dueDate !=
                                      null &&
                                  controller.pregnancyProfileList.last.dueDate!
                                      .isBefore(DateTime.now()),
                              onAddPressed: () =>
                                  controller.goToCreatePregnancyProfile(),
                            ),

                            const SizedBox(height: 16),

                            // Profiles section
                            controller.pregnancyProfileList.isEmpty
                                ? _buildEmptyState()
                                : _buildProfilesSection(),

                            const SizedBox(height: 32),

                            // Resources section
                            _buildResourcesSection(),

                            const SizedBox(height: 32),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pregnant_woman_rounded,
                  color: Colors.green[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Pregnancy Profiles',
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

  Widget _buildHeaderButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.grey[700],
          size: 22,
        ),
      ),
    );
  }

  // Summary cards with key statistics
  Widget _buildSummarySection() {
    // Calculate some stats for the summary cards
    int activeProfiles = 0;
    int completedProfiles = 0;
    int earliestDays = 999;
    String nearestProfile = "";

    for (var profile in controller.pregnancyProfileList) {
      if (profile.dueDate != null) {
        if (profile.dueDate!.isBefore(DateTime.now())) {
          completedProfiles++;
        } else {
          activeProfiles++;

          int daysLeft = profile.dueDate!.difference(DateTime.now()).inDays;
          if (daysLeft < earliestDays) {
            earliestDays = daysLeft;
            nearestProfile = profile.nickName ?? "Unknown";
          }
        }
      } else {
        activeProfiles++;
      }
    }

    return Row(
      children: [
        _buildSummaryCard(
          'Active Profiles',
          activeProfiles.toString(),
          Icons.favorite,
          Colors.green[600]!,
        ),
        _buildSummaryCard(
          'Completed Journeys',
          completedProfiles.toString(),
          Icons.check_circle,
          Colors.blue[600]!,
        ),
        _buildSummaryCard(
          nearestProfile.isNotEmpty ? 'Next Due Date' : 'Create Profile',
          nearestProfile.isNotEmpty ? '$earliestDays days left' : 'Get Started',
          nearestProfile.isNotEmpty ? Icons.event : Icons.add_circle,
          Colors.orange[600]!,
        ),
        _buildSummaryCard(
          'Total Profiles',
          controller.pregnancyProfileList.length.toString(),
          Icons.people,
          Colors.purple[600]!,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
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
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Info and action section
  Widget _buildInfoAndActionSection() {
    // Kiểm tra điều kiện hiển thị phần Quick Actions
    bool showQuickActions = controller.pregnancyProfileList.isEmpty ||
        (controller.pregnancyProfileList.isNotEmpty &&
            controller.pregnancyProfileList.last.dueDate != null &&
            (controller.pregnancyProfileList.last.dueDate!
                    .compareTo(DateTime.now()) <=
                0));

    return Container(
      padding: const EdgeInsets.all(24),
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
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: showQuickActions ? 3 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Your Pregnancy Journey',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Create a pregnancy profile to track fetal development, manage doctor appointments, record growth measurements, and get personalized information throughout your journey.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _buildFeatureChip('Weekly Updates', Icons.update),
                    _buildFeatureChip('Growth Tracking', Icons.show_chart),
                    _buildFeatureChip(
                        'Appointment Reminders', Icons.event_note),
                    _buildFeatureChip(
                        'Health Monitoring', Icons.favorite_border),
                  ],
                ),
              ],
            ),
          ),

          // Chỉ hiển thị phần Quick Actions khi thỏa mãn điều kiện
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.green[700],
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  // Section header with optional add button
  Widget _buildSectionHeader(String title, String subtitle, bool showAddButton,
      {VoidCallback? onAddPressed}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (showAddButton && onAddPressed != null)
          ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add),
            label: const Text('Add Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  // Empty state when no profiles exist
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pregnant_woman_rounded,
                size: 80,
                color: Colors.green[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No Pregnancy Profiles Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Create your first profile to start tracking your pregnancy journey",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () => controller.goToCreatePregnancyProfile(),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profiles organized in a more detailed table/list view
  Widget _buildProfilesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 50),
                Expanded(flex: 3, child: _buildTableHeader('Baby\'s Name')),
                Expanded(flex: 2, child: _buildTableHeader('Status')),
                Expanded(flex: 2, child: _buildTableHeader('Week')),
                Expanded(flex: 2, child: _buildTableHeader('Due Date')),
                Expanded(flex: 2, child: _buildTableHeader('Time Left')),
                const SizedBox(width: 100),
              ],
            ),
          ),

          // Table rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.pregnancyProfileList.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final profile = controller.pregnancyProfileList[index];
              return _buildProfileRow(profile, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildProfileRow(dynamic profile, int index) {
    bool isPastDue =
        profile.dueDate != null && profile.dueDate!.isBefore(DateTime.now());
    int daysRemaining = profile.dueDate != null
        ? profile.dueDate!.difference(DateTime.now()).inDays
        : 0;
    DateTime createdDate = profile.createdDate ?? DateTime.now();
    return InkWell(
      onTap: () => controller.goToPregnancyProfileDetail(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: index % 2 == 0 ? Colors.white : Colors.grey[50],
        child: Row(
          children: [
            // Profile image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPastDue ? Colors.orange[100] : Colors.green[100],
                image: const DecorationImage(
                  image: AssetImage("assets/images/pregnancy.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Baby name
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.nickName ?? 'Unnamed Baby',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    // Text(
                    //   'Created on ${DateFormat('yyyy-MM-dd').format(createdDate)}',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // Status
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPastDue
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPastDue ? Icons.check_circle : Icons.access_time,
                      size: 16,
                      color: isPastDue ? Colors.orange[700] : Colors.green[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isPastDue ? 'Completed' : 'Active',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color:
                            isPastDue ? Colors.orange[700] : Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Week
            Expanded(
              flex: 2,
              child: Text(
                'Week ${profile.pregnancyWeek ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // Due date
            Expanded(
              flex: 2,
              child: Text(
                profile.dueDate != null
                    ? DateFormat('yyyy-MM-dd').format(profile.dueDate!)
                    : 'Not set',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // Time left
            Expanded(
              flex: 2,
              child: Text(
                profile.dueDate != null
                    ? isPastDue
                        ? 'Completed'
                        : '$daysRemaining days left'
                    : 'N/A',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isPastDue ? FontWeight.bold : FontWeight.normal,
                  color: isPastDue ? Colors.orange[700] : Colors.grey[800],
                ),
              ),
            ),

            // Actions
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    onPressed: () =>
                        controller.goToUpdatePregnancyProfile(index),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => _showDeleteConfirmationDialog(index),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Resources section
  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Helpful Resources',
          'Articles and tools to help you during your pregnancy',
          false,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildResourceCard(
              'Pregnancy Week by Week',
              'Track fetal development each week',
              Colors.blue[700]!,
              Icons.calendar_today,
            )),
            Expanded(
                child: _buildResourceCard(
              'Nutrition Guidelines',
              'Recommended diet for pregnant women',
              Colors.green[700]!,
              Icons.restaurant_menu,
            )),
            Expanded(
                child: _buildResourceCard(
              'Exercise Tips',
              'Safe workouts during pregnancy',
              Colors.orange[700]!,
              Icons.fitness_center,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard(
      String title, String description, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                launchUrl(Uri.parse(
                    'https://www.babycenter.com/pregnancy/diet-and-fitness#subtopic-pregnancy-nutrients'));
              },
              icon: Icon(
                Icons.arrow_forward,
                color: color,
                size: 16,
              ),
              label: Text(
                'Learn More',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Delete confirmation dialog
  void _showDeleteConfirmationDialog(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'Are you sure you want to delete this pregnancy profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.deletePregnancyProfile(index); // Call delete method
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
