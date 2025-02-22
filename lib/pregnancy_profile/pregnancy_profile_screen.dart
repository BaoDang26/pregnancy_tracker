import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nhập thư viện intl

import '../controllers/pregnancy_profile_controller.dart';
import '../util/app_export.dart';
import '../widgets/pregnancy_profile_card.dart';

class PregnancyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pregnancyProfileController = Get.put(PregnancyProfileController());

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
            Obx(() {
              if (pregnancyProfileController.isLoading.value) {
                return const CircularProgressIndicator();
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Set the number of columns as needed
                      childAspectRatio: 1,
                    ),
                    padding: EdgeInsets.all(50),
                    itemCount:
                        pregnancyProfileController.pregnancyProfileList.length,
                    itemBuilder: (context, index) {
                      if (index <
                          pregnancyProfileController
                              .pregnancyProfileList.length) {
                        return PregnancyProfileCard(
                          pregnancyProfile: pregnancyProfileController
                              .pregnancyProfileList[index],
                        );
                      } else {
                        return _buildAddProfileCard(); // Add profile card
                      }
                    },
                  ),
                );
              }
            }),
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
