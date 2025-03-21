import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import '../controllers/create_fetal_growth_measurement_controller.dart';
import '../widgets/custom_elevated_button.dart';

class CreateFetalGrowthMeasurementScreen
    extends GetView<CreateFetalGrowthMeasurementController> {
  const CreateFetalGrowthMeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: appTheme.white,
          body: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appTheme.green500),
            ),
          ),
        );
      }
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF8EEF6), // Light pastel pink
                      Color(0xFFF5E1EB), // Pastel pink
                      Color(0xFFEBD7E6), // Light pink with purple
                      Color(0xFFE5D1E8), // Light lavender
                      Color(0xFFDBC5DE), // Darker lavender
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
                        const Row(
                          children: [
                            Icon(
                              Icons.pregnant_woman_rounded,
                              size: 48,
                              color: Color(0xFFAD6E8C), // Mauve/dark pink
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Create Fetal Growth Measurement',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAD6E8C), // Mauve/dark pink
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
                                Icons.assignment, // Changed to a document icon
                                color: Color(0xFFE57373), // Light pink
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Please enter your details',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      const Color(0xFF8E6C88).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller: controller.measurementDateController,
                              label: 'Measurement Date',
                              isDatePicker: true,
                              context: context,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller: controller.weightController,
                              label: 'Weight (g)',
                              validator: (value) =>
                                  controller.validateWeight(value!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller: controller.heightController,
                              label: 'Height (cm)',
                              validator: (value) =>
                                  controller.validateHeight(value!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller:
                                  controller.headCircumferenceController,
                              label: 'Head Circumference (cm)',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller:
                                  controller.bellyCircumferenceController,
                              label: 'Belly Circumference (cm)',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller: controller.heartRateController,
                              label: 'Heart Rate (bpm)',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller: controller.movementCountController,
                              label: 'Movement Count',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 600,
                            child: _buildInputField(
                              controller: controller.notesController,
                              label: 'Notes',
                              maxLines: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              child: CustomElevatedButton(
                                onPressed: () => Get.back(),
                                text: 'Cancel',
                                isCancel: true,
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 180,
                              child: CustomElevatedButton(
                                onPressed: () {
                                  controller.addFetalGrowthMeasurement();
                                },
                                text: 'Create',
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
              flex: 1,
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: isDatePicker,
        maxLines: maxLines ?? 1,
        validator: validator,
        onTap: isDatePicker && context != null
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFFAD6E8C), // Mauve/dark pink
                          onPrimary: Colors.white,
                          onSurface: Color(0xFF8E6C88),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: isDatePicker
              ? const Icon(Icons.calendar_today, color: Color(0xFF8E6C88))
              : null,
        ),
      ),
    );
  }
}
