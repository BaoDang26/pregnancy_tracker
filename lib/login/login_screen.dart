import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/login_controller.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_text_form_password_field.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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

            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.sidebarnarguest);
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: EdgeInsets.all(12),
                ),
              ),
            ),

            // Main content
            Row(
              children: [
                // Left panel with login form
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome text
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please sign in to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 48),

                          // Login form
                          Form(
                            key: controller.loginFormKey,
                            child: Column(
                              children: [
                                // Email field
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
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15), // Giảm chiều cao
                                ),
                                SizedBox(height: 16),

                                // Password field
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
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15), // Giảm chiều cao
                                  ),
                                ),
                                SizedBox(height: 32),

                                // Login button
                                Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 45,
                                    child: CustomElevatedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        if (controller.loginFormKey.currentState!.validate()) {
                                          await controller.login(context);
                                        }
                                      },
                                      text: 'Login',
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

                                // Error message
                                Obx(
                                  () => AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: controller.errorString.value.isEmpty ? 0 : 1,
                                    child: Text(
                                      controller.errorString.value,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32),

                                // Sign up link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(AppRoutes.register);
                                      },
                                      child: Text(
                                        'Sign Up',
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