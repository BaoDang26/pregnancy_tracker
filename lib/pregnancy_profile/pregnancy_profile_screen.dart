import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nhập thư viện intl

import '../util/app_export.dart';
import '../widgets/pregnancy_profile_card.dart';

class PregnancyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Who's using Chrome?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Khoảng cách giữa tiêu đề và nội dung
            Text(
              'With Chrome profiles you can separate all your Chrome stuff. Create profiles for friends and family, or split between work and fun.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20), // Khoảng cách giữa nội dung và lưới
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1,
                padding: EdgeInsets.all(50),
                children: [
                  PregnancyProfileCard(
                    nickname: 'Bao',
                    dueDate: DateTime.parse(
                        '2023-12-01'), // Đảm bảo truyền vào DateTime
                    pregnancyWeek: 12,
                  ),
                  PregnancyProfileCard(
                    nickname: 'Bảo',
                    dueDate: DateTime.parse('2023-11-15'),
                    pregnancyWeek: 10,
                  ),
                  PregnancyProfileCard(
                    nickname: 'Dang B',
                    dueDate: DateTime.parse('2024-01-10'),
                    pregnancyWeek: 8,
                  ),
                  PregnancyProfileCard(
                    nickname: 'fpt.edu.vn',
                    dueDate: DateTime.parse('2023-10-20'),
                    pregnancyWeek: 14,
                  ),
                  PregnancyProfileCard(
                    nickname: 'Work',
                    dueDate: DateTime.parse('2024-02-05'),
                    pregnancyWeek: 6,
                  ),
                  _buildAddProfileCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProfileCard() {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.createpregnancyprofile);
        },
        child: Center(
          child: Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
