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
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appTheme.green500),
            ),
          ),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB2DFDB),
                    Color(0xFF80CBC4),
                    Color(0xFF4DB6AC),
                    Color(0xFF26A69A),
                  ],
                ),
              ),
            ),

            // Main content
            Row(
              children: [
                // Left panel with register form
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please fill in the form to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 48),

                          Form(
                            key: controller.registerFormKey,
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
                                  hintTxt: 'Email address',
                                  suffixIcon: Icon(Icons.email_outlined, color: Color(0xFF4DB6AC)),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                ),
                                SizedBox(height: 24),

                                CustomTextFormField(
                                  controller: controller.fullNameController,
                                  onSaved: (value) {
                                    controller.fullName = value!;
                                  },
                                  validator: (value) {
                                    return controller.validateFullName(value!);
                                  },
                                  hintTxt: 'Full name',
                                  suffixIcon: Icon(Icons.person_outline, color: Color(0xFF4DB6AC)),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                ),
                                SizedBox(height: 24),

                                CustomTextPasswordField(
                                  controller: controller.passwordController,
                                  onSaved: (value) {
                                    controller.password = value!;
                                  },
                                  validator: (value) {
                                    return controller.validatePassword(value!);
                                  },
                                  hintTxt: 'Password',
                                  isObscure: controller.passwordVisible.value,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.passwordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFF4DB6AC),
                                    ),
                                    onPressed: () {
                                      controller.passwordVisible.value =
                                          !controller.passwordVisible.value;
                                    },
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                ),
                                SizedBox(height: 24),

                                CustomTextPasswordField(
                                  controller: controller.confirmPasswordController,
                                  onSaved: (value) {
                                    controller.confirmPassword = value!;
                                  },
                                  validator: (value) {
                                    return controller.validateConfirmPassword(value!);
                                  },
                                  hintTxt: 'Confirm password',
                                  isObscure: controller.confirmPasswordVisible.value,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.confirmPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFF4DB6AC),
                                    ),
                                    onPressed: () {
                                      controller.confirmPasswordVisible.value =
                                          !controller.confirmPasswordVisible.value;
                                    },
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                ),
                                SizedBox(height: 24),

                                CustomTextFormField(
                                  controller: controller.addressController,
                                  onSaved: (value) {
                                    controller.address = value!;
                                  },
                                  validator: (value) {
                                    return controller.validateAddress(value!);
                                  },
                                  hintTxt: 'Address',
                                  suffixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF4DB6AC)),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                ),
                                SizedBox(height: 24),

                                // Date of Birth field
                                Obx(
                                  () => CustomTextFormField(
                                    controller: TextEditingController(
                                      text: controller.dateOfBirth.value
                                    ),
                                    onSaved: (value) {
                                      controller.dateOfBirth.value = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select your date of birth";
                                      }
                                      return null;
                                    },
                                    enable: false,
                                    hintTxt: 'Select date of birth',
                                    labelText: 'Date of birth',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today_rounded, 
                                        color: Color(0xFF4DB6AC)
                                      ),
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
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                  ),
                                ),
                                SizedBox(height: 32),

                                Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 45,
                                    child: CustomElevatedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        await controller.registerEmail(context);
                                      },
                                      text: 'Register',
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 255, 206, 211),
                                        foregroundColor: Color.fromARGB(255, 86, 133, 154),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.offNamed(AppRoutes.login);
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Right panel with image
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
