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
                    Color.fromARGB(255, 164, 219, 186),
                    Color.fromARGB(255, 156, 227, 184),
                    Color.fromARGB(255, 137, 214, 169),
                    Color.fromARGB(255, 119, 209, 154),
                    Color.fromARGB(255, 102, 204, 140),
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
                    const Text(
                      'Create Account',
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
                    CustomTextFormField(
                      controller: controller.emailController,
                      onSaved: (value) {
                        controller.email = value!;
                      },
                      validator: (value) {
                        return controller.validateEmail(value!);
                      },
                      hintTxt: 'Enter your email',
                      suffixIcon: const Icon(Icons.email_outlined),
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
                      suffixIcon: const Icon(Icons.person_outline),
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
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            // chuyển đổi trạng thái ẩn hiện mât khẩu
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
                        isObscure: controller.confirmPasswordVisible.value,
                        suffixIcon: IconButton(
                          icon: controller.confirmPasswordVisible.value
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            // chuyển đổi trạng thái ẩn hiện mât khẩu
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
                      suffixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => TextField(
                        controller: TextEditingController(
                            text: controller.dateOfBirth.value),
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                controller.dateOfBirth.value =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              }
                            },
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Obx(
                        () => controller.isLoading.value
                            ? Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
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
                            : CustomElevatedButton(
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
                                text: 'Sign Up',
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
