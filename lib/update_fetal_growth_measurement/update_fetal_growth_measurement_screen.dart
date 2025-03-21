import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../controllers/update_fetal_growth_measurement_controller.dart';
import '../widgets/custom_elevated_button.dart';

class UpdateFetalGrowthMeasurementScreen
    extends GetView<UpdateFetalGrowthMeasurementController> {
  const UpdateFetalGrowthMeasurementScreen({super.key});

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
                    key: controller.fetalGrowthMeasurementFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề với icon
                        Row(
                          children: [
                            const Icon(
                              Icons.child_care,
                              size: 48,
                              color: Color(0xFFAD6E8C), // Mauve/hồng đậm
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Update Growth Measurement',
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
                                Icons.update,
                                color: Color(0xFFE57373), // Hồng nhạt
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Update Baby\'s Growth',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8E6C88), // Tím nhạt
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Please update the measurement details',
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

                        // Error message
                        Obx(() {
                          if (controller.errorMessage.isNotEmpty) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                border: Border.all(color: Colors.red[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.red),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      controller.errorMessage.value,
                                      style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red[300]),
                                    onPressed: () =>
                                        controller.errorMessage.value = '',
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),

                        _buildInputField(
                          controller: controller.measurementDateController,
                          label: 'Measurement Date',
                          isDatePicker: true,
                          context: context,
                          validator: (value) =>
                              controller.validateMeasurementDate(value!),
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.weightController,
                          label: 'Weight (g)',
                          validator: (value) =>
                              controller.validateWeight(value!),
                          icon: Icons.monitor_weight,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.heightController,
                          label: 'Height (cm)',
                          validator: (value) =>
                              controller.validateHeight(value!),
                          icon: Icons.height,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.headCircumferenceController,
                          label: 'Head Circumference (cm)',
                          icon: Icons.face,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.bellyCircumferenceController,
                          label: 'Belly Circumference (cm)',
                          icon: Icons.pregnant_woman,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.heartRateController,
                          label: 'Heart Rate (bpm)',
                          icon: Icons.favorite,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.movementCountController,
                          label: 'Movement Count',
                          icon: Icons.directions_run,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: controller.notesController,
                          label: 'Notes',
                          maxLines: 5,
                          icon: Icons.note_alt,
                        ),
                        const SizedBox(height: 28),

                        // Button actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        const Color(0xFF8E6C88), // Tím nhạt
                                    side: const BorderSide(
                                        color: Color(0xFF8E6C88), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_back),
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.updateFetalGrowthMeasurement();
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.update),
                                      SizedBox(width: 8),
                                      Text(
                                        'Update',
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool isDatePicker = false,
    int? maxLines,
    String? Function(String?)? validator,
    BuildContext? context,
    IconData? icon,
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
        readOnly: isDatePicker,
        maxLines: maxLines ?? 1,
        validator: validator,
        onTap: isDatePicker && context != null
            ? () async {
                // Lấy giá trị ngày hiện tại từ controller hoặc mặc định là ngày hiện tại
                DateTime initialDate;
                try {
                  initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
                } catch (e) {
                  initialDate = DateTime.now();
                }

                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFFAD6E8C), // Mauve/hồng đậm
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF8E6C88)),
          suffixIcon: Icon(
            icon,
            color: Color(0xFF8E6C88),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
