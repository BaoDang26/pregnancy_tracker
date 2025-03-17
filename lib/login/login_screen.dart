import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/login_controller.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import '../register/register_screen.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_text_form_password_field.dart'; // Import the signup screen

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor:
                  AlwaysStoppedAnimation(Color(0xFFAD6E8C)), // Mauve/hồng đậm
            ),
          ),
        );
      }
      return Scaffold(
        body: Form(
          key: controller.loginFormKey,
          child: Row(
            children: [
              // Left panel containing the login form
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App logo and title
                      const Row(
                        children: [
                          Icon(
                            Icons.child_friendly_outlined,
                            size: 48,
                            color: Color(0xFFAD6E8C), // Mauve/hồng đậm
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Pregnancy Tracker',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFAD6E8C), // Mauve/hồng đậm
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Welcome text with custom icon
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
                              Icons.favorite,
                              color: Color(0xFFE57373), // Hồng nhạt
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8E6C88), // Tím nhạt
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Please enter your details',
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

                      // Email field with custom decoration
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
                              borderSide: const BorderSide(
                                  color: Color(0xFFAD6E8C), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                        child: CustomTextFormField(
                          controller: controller.emailController,
                          onSaved: (value) {
                            controller.email = value!;
                          },
                          validator: (value) {
                            return controller.validateEmail(value!);
                          },
                          hintTxt: 'Enter your email',
                          suffixIcon: const Icon(
                            Icons.alternate_email,
                            color: Color(0xFF8E6C88),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password field with custom decoration
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
                              borderSide: const BorderSide(
                                  color: Color(0xFFAD6E8C), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                        child: Obx(
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
                                  ? const Icon(Icons.visibility,
                                      color: Color(0xFF8E6C88))
                                  : const Icon(Icons.visibility_off,
                                      color: Color(0xFF8E6C88)),
                              onPressed: () {
                                controller.passwordVisible.value =
                                    !controller.passwordVisible.value;
                              },
                            ),
                          ),
                        ),
                      ),

                      // Add Forgot Password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              controller.showForgotPasswordDialog(context),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: const Color(0xFF8E6C88),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login button with new styling
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (controller.loginFormKey.currentState!
                                  .validate()) {
                                await controller.login(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFAD6E8C), // Mauve/hồng đậm
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor:
                                  const Color(0xFFAD6E8C).withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.login_rounded),
                                SizedBox(width: 8),
                                Text(
                                  'Login',
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

                      const SizedBox(height: 16),

                      // Error message
                      Center(
                        child: Obx(
                          () => Text(
                            controller.errorString.value,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign up section with decorative divider
                      const Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xFFE5D1E8),
                                thickness: 1.5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Color(0xFF8E6C88),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xFFE5D1E8),
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign up button with new styling
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.register);
                            },
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
                              children: [
                                Icon(Icons.person_add_alt_1),
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
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
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
        ),
      );
    });
  }
}
