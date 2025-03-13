import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/register_controller.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_text_form_password_field.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          size: 48,
                          color: Color(0xFFAD6E8C), // Mauve/hồng đậm
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFAD6E8C), // Mauve/hồng đậm
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pregnant_woman_rounded,
                            color: Color(0xFFE57373), // Hồng nhạt
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Please enter your details',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8E6C88).withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFFAD6E8C), width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: controller.emailController,
                            onSaved: (value) {
                              controller.email = value!;
                            },
                            validator: (value) {
                              return controller.validateEmail(value!);
                            },
                            hintTxt: 'Enter your email',
                            suffixIcon: Icon(
                              Icons.alternate_email,
                              color: Color(0xFF8E6C88),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: controller.fullNameController,
                            onSaved: (value) {
                              controller.fullName = value!;
                            },
                            validator: (value) {
                              return controller.validateFullName(value!);
                            },
                            hintTxt: 'Enter your full name',
                            suffixIcon: Icon(
                              Icons.person_outline,
                              color: Color(0xFF8E6C88),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => CustomTextPasswordField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: controller.passwordController,
                              onSaved: (value) {
                                controller.password = value!;
                              },
                              validator: (value) {
                                return controller.validatePassword(value!);
                              },
                              hintTxt: 'Enter your password',
                              isObscure: controller.passwordVisible.value,
                              suffixIcon: IconButton(
                                icon: controller.passwordVisible.value
                                    ? Icon(Icons.visibility,
                                        color: Color(0xFF8E6C88))
                                    : Icon(Icons.visibility_off,
                                        color: Color(0xFF8E6C88)),
                                onPressed: () {
                                  controller.passwordVisible.value =
                                      !controller.passwordVisible.value;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => CustomTextPasswordField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: controller.rePasswordController,
                              onSaved: (value) {
                                controller.rePassword = value!;
                              },
                              validator: (value) {
                                return controller.validateRePassword(value!);
                              },
                              hintTxt: 'Enter confirm password',
                              isObscure:
                                  controller.confirmPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: controller.confirmPasswordVisible.value
                                    ? Icon(Icons.visibility,
                                        color: Color(0xFF8E6C88))
                                    : Icon(Icons.visibility_off,
                                        color: Color(0xFF8E6C88)),
                                onPressed: () {
                                  controller.confirmPasswordVisible.value =
                                      !controller.confirmPasswordVisible.value;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: controller.addressController,
                            onSaved: (value) {
                              controller.address = value!;
                            },
                            validator: (value) {
                              return controller.validateAddress(value!);
                            },
                            hintTxt: 'Enter your address',
                            suffixIcon: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF8E6C88),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => TextField(
                              controller: TextEditingController(
                                  text: controller.dateOfBirth.value),
                              decoration: InputDecoration(
                                labelText: 'Date of Birth',
                                labelStyle: TextStyle(
                                  color: Color(0xFF8E6C88),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFAD6E8C), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Color(0xFF8E6C88),
                                  ),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2101),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Color(
                                                  0xFFAD6E8C), // Mauve/hồng đậm
                                              onPrimary: Colors.white,
                                              surface: Colors.white,
                                              onSurface: Color(0xFF8E6C88),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (pickedDate != null) {
                                      controller.dateOfBirth.value =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    }
                                  },
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Obx(
                        () => controller.isLoading.value
                            ? Container(
                                width: 220,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFFAD6E8C), // Mauve/hồng đậm
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFAD6E8C).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Processing...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 220,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (controller.registerFormKey.currentState!
                                        .validate()) {
                                      controller.isLoading.value = true;
                                      try {
                                        await controller.registerEmail(context);
                                      } finally {
                                        controller.isLoading.value = false;
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(0xFFAD6E8C), // Mauve/hồng đậm
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor:
                                        Color(0xFFAD6E8C).withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.app_registration),
                                      SizedBox(width: 8),
                                      Text(
                                        'Sign Up',
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
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF8E6C88),
                          size: 18,
                        ),
                        label: Text(
                          'Back to Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8E6C88),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/logo.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
