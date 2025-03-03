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
      backgroundColor: Color(0xFFE0F2E9), // Màu xanh lá pastel
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do you have a Pregnancy Profile yet?",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Khoảng cách giữa tiêu đề và nội dung
            Text(
              'You can manage multiple Pregnancy Profiles in case of multiple pregnancies. If you don\'t have a Pregnancy Profile yet, create one for yourself and start tracking your pregnancy journey!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), // Khoảng cách giữa nội dung và lưới
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              } else if (controller.pregnancyProfileList.isEmpty ||
                  controller.pregnancyProfileList.last.dueDate != null &&
                      controller.pregnancyProfileList.last.dueDate!
                          .isBefore(DateTime.now())) {
                return _buildAddProfileCard(); // Hiển thị thẻ thêm nếu điều kiện thỏa mãn
              } else {
                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // Number of columns
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio:
                          1.2, // Adjust the aspect ratio as needed
                    ),
                    itemCount: controller.pregnancyProfileList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // controller.onSelectFood(index);
                        },
                        child: Stack(
                          children: [
                            PregnancyProfileCard(
                              photoUrl: "assets/images/pregnancy-profile.png",
                              title:
                                  "${controller.pregnancyProfileList[index].nickName}",
                              content1:
                                  "Pregnancy Week: ${controller.pregnancyProfileList[index].pregnancyWeek}",
                              // content2:
                              //     "${controller.foodModels[index].serving}",
                              content3:
                                  "Due Date: ${controller.pregnancyProfileList[index].dueDate?.format()}",
                              onTitleTap: () {
                                controller.goToPregnancyProfileDetail(index);
                              },
                              onEditTap: () {
                                // controller.goToEditPregnancyProfile(index);
                              },
                            ),
                            // Thêm nút edit ở góc phải trên
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.green[700]),
                                  onPressed: () {
                                    // controller.goToEditPregnancyProfile(index);
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.all(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
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
      color: Color.fromARGB(255, 48, 168, 78),
      elevation: 4,
      child: InkWell(
        onTap: () {
          controller.goToCreatePregnancyProfile();
        },
        child: Container(
          width: 300, // Chiều rộng của ô vuông
          height: 300, // Chiều cao của ô vuông
          child: Center(
            child: Icon(Icons.add, size: 60),
          ),
        ),
      ),
    );
  }
}
