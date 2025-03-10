import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nhập thư viện intl

import '../controllers/pregnancy_profile_controller.dart';
import '../util/app_export.dart';
import '../widgets/pregnancy_profile_card.dart';

class PregnancyProfileScreen extends GetView<PregnancyProfileController> {
  const PregnancyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2E9),
              Color(0xFFD5EED9),
              Color(0xFFCAEAD0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildInfoSection(),
              SizedBox(height: 16),
              Expanded(
                child: _buildProfilesSection(),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.pregnant_woman_rounded,
              size: 38,
              color: Colors.green[700],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "Pregnancy Profiles",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.pink[400],
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Do you have a Pregnancy Profile yet?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You can manage multiple Pregnancy Profiles in case of multiple pregnancies. If you don\'t have a Pregnancy Profile yet, create one for yourself and start tracking your pregnancy journey!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
            strokeWidth: 4,
          ),
        );
      } else if (controller.pregnancyProfileList.isEmpty) {
        // Nếu không có profile, chỉ hiện nút thêm
        return _buildEmptyState();
      } else {
        // Có profiles rồi, hiển thị grid và kiểm tra xem có cần hiện nút thêm không
        bool showAddButton = false;

        // Kiểm tra xem profile gần nhất có dueDate trước ngày hôm nay không
        if (controller.pregnancyProfileList.last.dueDate != null &&
            controller.pregnancyProfileList.last.dueDate!
                .isBefore(DateTime.now())) {
          showAddButton = true;
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Profiles",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  if (showAddButton)
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.goToCreatePregnancyProfile();
                      },
                      icon: Icon(Icons.add_circle_outline, size: 24),
                      label: Text(
                        "Add New Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: controller.pregnancyProfileList.isEmpty
                  ? _buildEmptyState()
                  : _buildProfileGrid(),
            ),
          ],
        );
      }
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              size: 100,
              color: Colors.green[300],
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Create Your First Profile",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Start tracking your pregnancy journey",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: 220,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.goToCreatePregnancyProfile();
              },
              icon: Icon(Icons.add_circle_outline, size: 28),
              label: Text(
                "Add Profile",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.pregnancyProfileList.length,
        itemBuilder: (context, index) {
          final profile = controller.pregnancyProfileList[index];
          return _buildProfileCard(profile, index);
        },
      ),
    );
  }

  Widget _buildProfileCard(dynamic profile, int index) {
    // Kiểm tra nếu dueDate đã qua hay chưa
    bool isPastDue =
        profile.dueDate != null && profile.dueDate!.isBefore(DateTime.now());

    // Tính số ngày còn lại đến dueDate
    int daysRemaining = 0;
    if (profile.dueDate != null) {
      daysRemaining = profile.dueDate!.difference(DateTime.now()).inDays;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.goToPregnancyProfileDetail(index);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPastDue
                          ? [Colors.orange[300]!, Colors.orange[400]!]
                          : [Colors.green[300]!, Colors.green[400]!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),

                // Profile Image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isPastDue
                              ? [Colors.orange[50]!, Colors.white]
                              : [Colors.green[50]!, Colors.white],
                        ),
                      ),
                    ),
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage("assets/images/pregnancy.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Edit Button
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit,
                              color: isPastDue
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                              size: 18),
                          onPressed: () {
                            // controller.goToEditPregnancyProfile(index);
                          },
                          constraints:
                              BoxConstraints.tightFor(width: 32, height: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),

                // Profile Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Baby's nickname: ${profile.nickName}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: isPastDue
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "Week ${profile.pregnancyWeek}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPastDue
                                  ? Icons.event_available
                                  : Icons.event_note,
                              size: 16,
                              color: isPastDue
                                  ? Colors.orange[700]
                                  : Colors.green[700],
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                profile.dueDate != null
                                    ? isPastDue
                                        ? "Born ${DateFormat('MMM d').format(profile.dueDate!)}"
                                        : "${daysRemaining} days left"
                                    : "No due date",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Status Indicator
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isPastDue ? Colors.orange[50] : Colors.green[50],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isPastDue ? Icons.check_circle : Icons.play_circle_fill,
                        size: 16,
                        color:
                            isPastDue ? Colors.orange[700] : Colors.green[700],
                      ),
                      SizedBox(width: 4),
                      Text(
                        isPastDue ? "Completed" : "Active",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isPastDue
                              ? Colors.orange[700]
                              : Colors.green[700],
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
    );
  }
}
