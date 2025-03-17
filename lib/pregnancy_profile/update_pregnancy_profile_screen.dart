import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/update_pregnancy_profile_controller.dart';

class UpdatePregnancyProfileScreen
    extends GetView<UpdatePregnancyProfileController> {
  const UpdatePregnancyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Pregnancy Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFF5E1EB), // Soft pink
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF614051)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5E1EB), // Soft pink
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.pregnancyProfileModel.value.id == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E6C88)),
              ),
            );
          }

          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 30),
                    _buildUpdateForm(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFAD6E8C).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.pregnant_woman_rounded,
            size: 80,
            color: Color(0xFFAD6E8C),
          ),
        ),
        SizedBox(height: 24),
        Text(
          "Update Your Pregnancy Profile",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF614051),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Customize details about your pregnancy journey",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUpdateForm() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: controller.updatePregnancyProfileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pregnancy Information Section
            _buildSectionHeader("Pregnancy Nickname", Icons.favorite_border),
            SizedBox(height: 20),
            TextFormField(
              controller: controller.nickNameController,
              decoration: InputDecoration(
                labelText: 'Nickname for this pregnancy',
                hintText: 'e.g., "Little Bean", "Baby Joy"',
                prefixIcon:
                    Icon(Icons.emoji_emotions, color: Color(0xFFAD6E8C)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFAD6E8C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFAD6E8C), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) => controller.validateNickName(value!),
              onSaved: (value) => controller.nickName = value!,
            ),

            SizedBox(height: 30),
            _buildSectionHeader("Additional Notes", Icons.notes),
            SizedBox(height: 20),
            TextFormField(
              controller: controller.notesController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText:
                    'Add any important details or reminders about your pregnancy',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.edit_note, color: Color(0xFFAD6E8C)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFAD6E8C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFAD6E8C), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onSaved: (value) => controller.notes = value!,
            ),

            SizedBox(height: 40),
            Center(
              child: Container(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.updatePregnancyProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAD6E8C),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: Color(0xFFAD6E8C).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Updating...",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Update Profile",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    )),
              ),
            ),

            SizedBox(height: 24),
            if (controller.errorString.isNotEmpty)
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        controller.errorString.value,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF8E6C88),
          size: 24,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF614051),
          ),
        ),
      ],
    );
  }
}
