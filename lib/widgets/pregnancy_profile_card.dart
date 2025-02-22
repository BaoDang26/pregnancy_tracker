import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/models/pregnancy_profile_model.dart';

import '../util/app_export.dart'; // Nhập thư viện intl

class PregnancyProfileCard extends StatelessWidget {
  final PregnancyProfileModel pregnancyProfile;

  const PregnancyProfileCard({
    Key? key,
    required this.pregnancyProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final pregnancyProfileController = Get.put(PregnancyProfileController());
    return GestureDetector(
      onTap: () {
        // Get.toNamed(AppRoutes.pregnancyprofiledetails, arguments: [pregnancyProfileController.pregnancyProfileList[index]]);
        print('Pregnancy Profile Card tapped!');
      },
      child: Container(
        width: 10, // Đặt chiều rộng nhỏ hơn
        height: 10, // Đặt chiều cao nhỏ hơn
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow.shade100,
              Colors.yellow.shade300
            ], // Gradient vàng nhạt
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8), // Bo góc
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Thêm padding để tạo khoảng cách
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(pregnancyProfile.nickName ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25)), // Giảm cỡ chữ nickname
              Text('Pregnancy Week: ${pregnancyProfile.pregnancyWeek}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15)), // Giảm cỡ chữ pregnancyWeek
              Text(
                'Due Date: ${DateFormat('yyyy-MM-dd').format(pregnancyProfile.dueDate ?? DateTime.now())}', // Thêm chữ "Due Date: "
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15), // Giảm cỡ chữ dueDate
              ),
              SizedBox(height: 5), // Giảm khoảng cách
            ],
          ),
        ),
      ),
    );
  }
}
