import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../controllers/create_pregnancy_profile_controller.dart';
import '../widgets/custom_elevated_button.dart';

class CreatePregnancyProfileScreen
    extends GetView<CreatePregnancyProfileController> {
  const CreatePregnancyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: const AlwaysStoppedAnimation(
                  Color(0xFFAD6E8C)), // Mauve/hồng đậm
            ),
          ),
        );
      }
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF8EEF6), // Hồng pastel nhạt
                      Color(0xFFF5E1EB), // Hồng pastel
                      Color(0xFFEBD7E6), // Hồng nhạt pha tím
                      Color(0xFFE5D1E8), // Tím lavender nhạt
                      Color(0xFFDBC5DE), // Tím lavender đậm hơn
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.pregnancyProfileFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề với icon
                        Row(
                          children: [
                            const Icon(
                              Icons.pregnant_woman,
                              size: 48,
                              color: Color(0xFFAD6E8C), // Mauve/hồng đậm
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Pregnancy Profile',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color:
                                    const Color(0xFFAD6E8C), // Mauve/hồng đậm
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Form intro
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.child_friendly,
                                color: Color(0xFFE57373), // Hồng nhạt
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Create Baby Profile',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8E6C88), // Tím nhạt
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Please enter your pregnancy details',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF8E6C88)
                                          .withOpacity(0.8), // Tím nhạt
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Trường nhập tên
                        _buildInputField(
                          controller: controller.nickNameController,
                          label: 'Baby\'s nickname',
                          icon: Icons.baby_changing_station,
                          validator: (value) {
                            return controller.validateNickName(value!);
                          },
                        ),

                        const SizedBox(height: 20),

                        // Container chọn option
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFFAD6E8C),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Choose one option:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF8E6C88),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildOptionTile(
                                title: 'Enter Last Period Date',
                                subtitle: 'We will calculate your due date',
                                icon: Icons.calendar_today,
                                isSelected: controller
                                    .lastPeriodDateController.text.isNotEmpty,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 280)),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFFAD6E8C),
                                            onPrimary: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    String formattedLPD =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    controller.lastPeriodDateController.text =
                                        formattedLPD;

                                    DateTime dueDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month + 9,
                                      pickedDate.day + 7,
                                    );

                                    if (pickedDate.month + 9 > 12) {
                                      dueDate = DateTime(
                                        pickedDate.year + 1,
                                        (pickedDate.month + 9) - 12,
                                        pickedDate.day + 7,
                                      );
                                    }

                                    controller.dueDateController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(dueDate);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildOptionTile(
                                title: 'Enter Due Date',
                                subtitle:
                                    'If you already know your due date from doctor',
                                icon: Icons.event,
                                isSelected: controller
                                        .dueDateController.text.isNotEmpty &&
                                    controller
                                        .lastPeriodDateController.text.isEmpty,
                                onTap: () async {
                                  DateTime now = DateTime.now();
                                  DateTime minDate =
                                      now.add(const Duration(days: 1));
                                  DateTime maxDate =
                                      now.add(const Duration(days: 280));

                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: minDate,
                                    firstDate: minDate,
                                    lastDate: maxDate,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFFAD6E8C),
                                            onPrimary: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    controller.dueDateController.text =
                                        formattedDate;

                                    DateTime lastPeriodDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month - 9,
                                      pickedDate.day - 7,
                                    );

                                    if (pickedDate.month - 9 < 1) {
                                      lastPeriodDate = DateTime(
                                        pickedDate.year - 1,
                                        12 + (pickedDate.month - 9),
                                        pickedDate.day - 7,
                                      );
                                    }

                                    controller.lastPeriodDateController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(lastPeriodDate);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Trường last period date
                        _buildInputField(
                          controller: controller.lastPeriodDateController,
                          label: 'Last Period Date',
                          icon: Icons.calendar_today,
                          readOnly: true,
                        ),

                        const SizedBox(height: 16),

                        // Trường due date
                        _buildInputField(
                          controller: controller.dueDateController,
                          label: 'Due Date',
                          icon: Icons.event_available,
                          readOnly: true,
                        ),

                        const SizedBox(height: 16),

                        // Trường notes
                        _buildInputField(
                          controller: controller.notesController,
                          label: 'Notes',
                          icon: Icons.note_alt,
                          maxLines: 3,
                          hint: 'Enter any additional notes here...',
                        ),

                        const SizedBox(height: 20),

                        // Pregnancy dates summary
                        if (controller
                                .lastPeriodDateController.text.isNotEmpty ||
                            controller.dueDateController.text.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: Color(0xFFAD6E8C),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Your Pregnancy Dates',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF8E6C88),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8EEF6)
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Color(0xFF8E6C88),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Last Period Date:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xFF8E6C88),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              controller
                                                  .lastPeriodDateController
                                                  .text,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE5D1E8)
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.event_available,
                                                  size: 16,
                                                  color: Color(0xFF8E6C88),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Due Date:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xFF8E6C88),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              controller.dueDateController.text,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFAD6E8C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 28),

                        // Create profile button & Cancel button
                        Center(
                          child: Row(
                            children: [
                              // Nút Cancel
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.back(); // Quay lại màn hình trước đó
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.grey[800],
                                      elevation: 2,
                                      shadowColor: Colors.grey.withOpacity(0.4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cancel),
                                        SizedBox(width: 8),
                                        Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 16), // Khoảng cách giữa 2 nút
                              // Nút Create Profile (đã có sẵn)
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (controller
                                          .pregnancyProfileFormKey.currentState!
                                          .validate()) {
                                        controller.pregnancyProfileFormKey
                                            .currentState!
                                            .save();
                                        await controller
                                            .createPregnancyProfile();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(
                                          0xFFAD6E8C), // Mauve/hồng đậm
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      shadowColor: const Color(0xFFAD6E8C)
                                          .withOpacity(0.4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save),
                                        SizedBox(width: 8),
                                        Text(
                                          'Create Profile',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper widget để tạo các trường nhập liệu
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool readOnly = false,
    int? maxLines,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Theme(
      data: ThemeData().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFAD6E8C), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines ?? 1,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Color(0xFF8E6C88)),
          suffixIcon: Icon(
            icon,
            color: const Color(0xFF8E6C88),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Helper widget để tạo các tile lựa chọn
  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEBD7E6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFAD6E8C) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF8E6C88) : Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF8E6C88).withOpacity(0.8)
                : Colors.grey.shade600,
          ),
        ),
        leading: Icon(
          icon,
          color: isSelected
              ? const Color(0xFFAD6E8C)
              : const Color(0xFF8E6C88).withOpacity(0.6),
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }
}
