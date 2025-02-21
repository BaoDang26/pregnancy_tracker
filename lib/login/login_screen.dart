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
    bool _isPasswordVisible = false;
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
        body: Form(
          key: controller.loginFormKey,
          child: Row(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pregnancy Tracker',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(fontSize: 24),
                      ),
                      const Text(
                        'Please enter your details',
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      //email fields
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
                      const SizedBox(height: 20),
                      Center(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            // Handle login action
                            if (controller.loginFormKey.currentState!
                                .validate()) {
                              await controller.login(context);
                            }
                          },
                          text: 'Login',
                        ),
                      ),
                      Center(
                        child: Obx(
                          () => Text(
                            controller.errorString.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: const Text(
                            'If you don\'t have an account, please sign up'),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.register);
                          },
                          text: 'Sign Up',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      // const Text(
                      //   'Join the millions of smart investors who trust us to manage their finances.',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 12),
                      // ),
                    ],
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
        ),
      );
    });
  }
}
