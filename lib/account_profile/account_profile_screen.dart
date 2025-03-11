import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import '../controllers/account_profile_controller.dart';

class AccountProfileScreen extends GetView<AccountProfileController> {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[50]!,
                Colors.blue[100]!,
              ],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          ),
        );
      }

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[50]!,
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 32,
                        color: Colors.blue[700],
                      ),
                      SizedBox(width: 12),
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Area
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Avatar & Quick info
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: Colors.blue.withOpacity(0.2),
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.blue[50]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Avatar with edit badge
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue[300]!,
                                          Colors.blue[700]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(controller
                                              .accountProfileModel
                                              .value
                                              .avatarUrl ??
                                          'https://res.cloudinary.com/dlipvbdwi/image/upload/v1705123226/Capstone/avatar_default_zhjqey.jpg'),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      // child: CircleAvatar(
                                      //   radius: 18,
                                      //   backgroundColor: Colors.blue[600],
                                      //   child: Icon(
                                      //     Icons.camera_alt,
                                      //     color: Colors.white,
                                      //     size: 18,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),

                              // Name
                              Text(
                                controller.accountProfileModel.value.fullName ??
                                    'Not set',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 8),

                              // Email badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blue[200]!,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 16,
                                      color: Colors.blue[700],
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      controller.accountProfileModel.value
                                              .email ??
                                          'No email',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 32),

                              // Divider with Info label
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.blue[200]),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Quick Stats',
                                      style: TextStyle(
                                        color: Colors.blue[300],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.blue[200]),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24),

                              // Quick Stats
                              // _buildQuickStatItem(
                              //   icon: Icons.calendar_today,
                              //   label: 'Member Since',
                              //   value: 'May 2023',
                              // ),

                              SizedBox(height: 12),

                              // _buildQuickStatItem(
                              //   icon: Icons.pregnant_woman,
                              //   label: 'Pregnancy Profiles',
                              //   value: '1',
                              // ),

                              // SizedBox(height: 12),

                              _buildQuickStatItem(
                                icon: Icons.star,
                                label: 'Premium Status',
                                value: controller.accountProfileModel.value
                                            .roleName ==
                                        'ROLE_USER_PREMIUM'
                                    ? 'Active'
                                    : (controller.accountProfileModel.value
                                                .roleName ==
                                            'ROLE_USER'
                                        ? 'Deactive'
                                        : 'Not set'),
                                valueColor: controller.accountProfileModel.value
                                            .roleName ==
                                        'ROLE_USER_PREMIUM'
                                    ? Colors.green[600]
                                    : Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 24),

                    // Right Column - Detailed Info & Forms
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Info Panel - Changed to Text display
                          _buildInfoPanel(
                            title: 'Personal Information',
                            icon: Icons.person,
                            color: Colors.blue[700]!,
                            content: Column(
                              children: [
                                _buildInfoRow(
                                  label: 'Full Name',
                                  icon: Icons.badge,
                                  value: controller
                                          .accountProfileModel.value.fullName ??
                                      'Not set',
                                ),
                                SizedBox(height: 16),
                                _buildInfoRow(
                                  label: 'Address',
                                  icon: Icons.home,
                                  value: controller
                                          .accountProfileModel.value.address ??
                                      'Not set',
                                ),
                                SizedBox(height: 16),
                                _buildInfoRow(
                                  label: 'Birthday',
                                  icon: Icons.cake,
                                  value: controller.accountProfileModel.value
                                              .dateOfBirth !=
                                          null
                                      ? DateFormat('yyyy-MM-dd').format(
                                          controller.accountProfileModel.value
                                              .dateOfBirth!)
                                      : 'Not set',
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // Security Panel
                          _buildInfoPanel(
                            title: 'Security',
                            icon: Icons.security,
                            color: Colors.indigo[700]!,
                            content: Column(
                              children: [
                                _buildFormField(
                                  label: 'Email',
                                  icon: Icons.mail,
                                  hintText: controller
                                      .accountProfileModel.value.email,
                                  readOnly: true,
                                ),
                                SizedBox(height: 20),
                                _buildFormField(
                                  label: 'Password',
                                  icon: Icons.lock,
                                  hintText: '********',
                                  readOnly: true,
                                  obscureText: true,
                                  trailing: TextButton(
                                    onPressed: () {
                                      // Change password logic
                                    },
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          // Action Buttons - Updated Save Changes button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomElevatedButton(
                                onPressed: () {
                                  //  Update Account Profile logic
                                  controller.goToUpdateAccountProfile();
                                },
                                text: 'Update',
                                icon: Icons.edit,
                                backgroundColor: Colors.blue[50],
                                textColor: Colors.blue[700],
                                gradientColors: [
                                  Colors.red[50]!,
                                  Colors.red[100]!,
                                ],
                                width: 150,
                              ),
                              CustomElevatedButton(
                                onPressed: () {
                                  // Logout logic
                                  controller.logout();
                                },
                                text: 'Logout',
                                icon: Icons.logout,
                                backgroundColor: Colors.red[50],
                                textColor: Colors.red[700],
                                gradientColors: [
                                  Colors.red[50]!,
                                  Colors.red[100]!,
                                ],
                                width: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Helper method for quick stat items
  Widget _buildQuickStatItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.blue[700],
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method for info panels
  Widget _buildInfoPanel({
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // Panel Content
          Container(
            padding: EdgeInsets.all(20),
            child: content,
          ),
        ],
      ),
    );
  }

  // Updated form field method to use TextFormField instead of TextField
  Widget _buildFormField({
    required String label,
    required IconData icon,
    required String? hintText,
    bool readOnly = false,
    bool obscureText = false,
    Function()? onTap,
    Widget? trailing,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: obscureText,
            onTap: onTap,
            validator: validator,
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter information',
              prefixIcon: Icon(
                icon,
                color: Colors.blue[400],
                size: 20,
              ),
              suffixIcon: trailing,
              filled: true,
              fillColor: readOnly ? Colors.grey[50] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blue[200]!,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blue[100]!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blue[400]!,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red[400]!,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red[400]!,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // New method to select birthday
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.accountProfileModel.value.dateOfBirth != null
          ? DateTime.parse(
              controller.accountProfileModel.value.dateOfBirth!.toString())
          : DateTime.now()
              .subtract(Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.dateOfBirthController.text =
          DateFormat('yyyy-MM-dd').format(picked);

      // Update the text field (you'll need to add a controller for this field)
      // birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // New method to build info row
  Widget _buildInfoRow({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.blue[700],
        ),
        SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
