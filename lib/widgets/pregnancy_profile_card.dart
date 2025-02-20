import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util/app_export.dart'; // Nhập thư viện intl

class PregnancyProfileCard extends StatelessWidget {
  final String nickname;
  final DateTime dueDate; // Đảm bảo dueDate là kiểu DateTime
  final int pregnancyWeek;

  const PregnancyProfileCard({
    Key? key,
    required this.nickname,
    required this.dueDate,
    required this.pregnancyWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.pregnancyprofiledetails);
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
              Text(nickname,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25)), // Giảm cỡ chữ nickname
              Text('Pregnancy Week: $pregnancyWeek',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15)), // Giảm cỡ chữ pregnancyWeek
              Text(
                'Due Date: ${DateFormat('yyyy-MM-dd').format(dueDate)}', // Thêm chữ "Due Date: "
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
