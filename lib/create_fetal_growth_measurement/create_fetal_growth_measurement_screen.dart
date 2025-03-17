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
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green[50]!,
                      Colors.green[100]!,
                      Colors.green[200]!.withOpacity(0.5),
                      Colors.green[300]!.withOpacity(0.3),
                      Colors.green[400]!.withOpacity(0.2),
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
                        const Text(
                          'Create Fetal Growth Measurement',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Please enter your details',
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          if (controller.errorMessage.isNotEmpty) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                border: Border.all(color: Colors.red[300]!),
                                borderRadius: BorderRadius.circular(8),
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
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.weightController,
                          label: 'Weight (g)',
                          validator: (value) =>
                              controller.validateWeight(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.heightController,
                          label: 'Height (cm)',
                          validator: (value) =>
                              controller.validateHeight(value!),
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.headCircumferenceController,
                          label: 'Head Circumference (cm)',
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.bellyCircumferenceController,
                          label: 'Belly Circumference (cm)',
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.heartRateController,
                          label: 'Heart Rate (bpm)',
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.movementCountController,
                          label: 'Movement Count',
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          controller: controller.notesController,
                          label: 'Notes',
                          maxLines: 5,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: () =>
                                    // Navigator.of(Get.context!).pop(),
                                    Get.back(),
                                text: 'Cancel',
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
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
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[50]!,
            Colors.green[100]!,
            Colors.green[200]!.withOpacity(0.5),
            Colors.green[300]!.withOpacity(0.3),
            Colors.green[400]!.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5),
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
                          primary: Colors.green,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.green[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.green[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.green[500]!),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          suffixIcon: isDatePicker
              ? const Icon(Icons.calendar_today, color: Colors.green)
              : null,
        ),
      ),
    );
  }
}
