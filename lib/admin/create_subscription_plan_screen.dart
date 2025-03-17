import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/create_subscription_plan_controller.dart';
import '../util/app_export.dart';

class CreateSubscriptionPlanScreen
    extends GetView<CreateSubscriptionPlanController> {
  const CreateSubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Subscription Plan'),
        backgroundColor: Color(0xFFE5D1E8),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.cancel_outlined, color: Colors.red[700]),
            label: Text(
              'Cancel',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8EEF6), // Light pastel pink
              Color(0xFFF5E1EB), // Pastel pink
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Container(
              width: 800, // Fixed width for desktop view
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFEBD7E6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 32,
            color: Color(0xFF614051),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Subscription Plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Create a new subscription plan for users',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Form(
        key: controller.subscriptionPlanFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Information Section
            _buildSectionHeader('Plan Information', Icons.info_outline),
            SizedBox(height: 20),

            // Name Field
            _buildInputField(
              label: 'Plan Name',
              hint: 'Enter plan name (e.g. Premium Monthly)',
              controller: controller.nameController,
              validator: controller.validateName,
              onSaved: (value) => controller.name = value!,
              icon: Icons.card_membership,
              maxLength: 100,
            ),
            SizedBox(height: 24),

            // Pricing & Duration Section
            _buildSectionHeader('Pricing & Duration', Icons.payments_outlined),
            SizedBox(height: 20),

            // Two columns for price and duration
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Field
                Expanded(
                  child: _buildInputField(
                    label: 'Price (VND)',
                    hint: 'Enter price amount',
                    controller: controller.priceController,
                    validator: controller.validatePrice,
                    onSaved: (value) => controller.price = value!,
                    icon: Icons.monetization_on_outlined,
                    isNumberInput: true,
                    maxLength: 15,
                  ),
                ),
                SizedBox(width: 24),
                // Duration Field
                Expanded(
                  child: _buildInputField(
                    label: 'Duration (Days)',
                    hint: 'Enter number of days',
                    controller: controller.durationController,
                    validator: controller.validateDuration,
                    onSaved: (value) => controller.duration = value!,
                    icon: Icons.calendar_today,
                    isNumberInput: true,
                    maxLength: 5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Description Section
            _buildSectionHeader('Description', Icons.description_outlined),
            SizedBox(height: 20),

            // Description Field
            _buildInputField(
              label: 'Plan Description',
              hint: 'Enter detailed description of this subscription plan',
              controller: controller.descriptionController,
              validator: controller.validateDescription,
              onSaved: (value) => controller.description = value!,
              icon: Icons.description_outlined,
              isMultiline: true,
              maxLength: 500,
            ),
            SizedBox(height: 40),

            // Submit Button
            Center(
              child: Obx(
                () => controller.isLoading.value
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF8E6C88)),
                      )
                    : SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: Icon(Icons.check_circle_outline),
                          label: Text(
                            'Create Subscription Plan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8E6C88),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
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
          size: 20,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF614051),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String) validator,
    required Function(String?) onSaved,
    required IconData icon,
    bool isMultiline = false,
    bool isNumberInput = false,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF614051),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Color(0xFF8E6C88)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xFF8E6C88),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: isMultiline ? 16 : 0,
              horizontal: 16,
            ),
            counterText: '',
          ),
          maxLength: maxLength,
          maxLines: isMultiline ? 5 : 1,
          keyboardType: isNumberInput
              ? TextInputType.number
              : (isMultiline ? TextInputType.multiline : TextInputType.text),
          inputFormatters:
              isNumberInput ? [FilteringTextInputFormatter.digitsOnly] : null,
          validator: (value) => validator(value!),
          onSaved: onSaved,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    // Hide keyboard
    FocusScope.of(Get.context!).unfocus();

    // Call controller method to create subscription plan
    controller.createSubscriptionPlan().then((_) {
      // If loading is false and no error, it means success
      if (!controller.isLoading.value && controller.errorString.isEmpty) {
        // Clear the form
        controller.nameController.clear();
        controller.priceController.clear();
        controller.durationController.clear();
        controller.descriptionController.clear();

        // Show success dialog
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Subscription Plan Created',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF614051),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'The subscription plan has been successfully created.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          Get.back(); // Go back to subscription plan list
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8E6C88),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Return to List'),
                      ),
                      SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => Get.back(), // Close dialog only
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF8E6C88),
                          side: BorderSide(color: Color(0xFF8E6C88)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Create Another'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
