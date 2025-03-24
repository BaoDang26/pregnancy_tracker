import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/register_controller.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;

import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_text_form_password_field.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
                      key: controller.registerFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
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
                                  Icons.pregnant_woman_rounded,
                                  color: Color(0xFFE57373), // Hồng nhạt
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Please enter your details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xFF8E6C88)
                                        .withOpacity(0.8),
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
                                  borderSide: const BorderSide(
                                      color: Color(0xFFAD6E8C), width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
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
                                  suffixIcon: const Icon(
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
                                  suffixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Color(0xFF8E6C88),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomTextPasswordField(
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
                                const SizedBox(height: 16),
                                CustomTextPasswordField(
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: controller.rePasswordController,
                                  onSaved: (value) {
                                    controller.rePassword = value!;
                                  },
                                  validator: (value) {
                                    return controller
                                        .validateRePassword(value!);
                                  },
                                  hintTxt: 'Enter confirm password',
                                  isObscure:
                                      controller.confirmPasswordVisible.value,
                                  suffixIcon: IconButton(
                                    icon:
                                        controller.confirmPasswordVisible.value
                                            ? const Icon(Icons.visibility,
                                                color: Color(0xFF8E6C88))
                                            : const Icon(Icons.visibility_off,
                                                color: Color(0xFF8E6C88)),
                                    onPressed: () {
                                      controller.confirmPasswordVisible.value =
                                          !controller
                                              .confirmPasswordVisible.value;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonFormField<dvhcvn.Level1>(
                                    decoration: const InputDecoration(
                                      labelText: 'Province/City',
                                      labelStyle:
                                          TextStyle(color: Color(0xFF8E6C88)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.location_city,
                                        color: Color(0xFF8E6C88)),
                                    value: controller.selectedLevel1.value,
                                    onChanged: (dvhcvn.Level1? newValue) {
                                      if (newValue != null) {
                                        controller.selectedLevel1.value =
                                            newValue;
                                      }
                                    },
                                    items: () {
                                      var sorted = dvhcvn.level1s.toList();
                                      sorted.sort(
                                          (a, b) => a.name.compareTo(b.name));
                                      return sorted
                                          .map<DropdownMenuItem<dvhcvn.Level1>>(
                                              (dvhcvn.Level1 value) {
                                        return DropdownMenuItem<dvhcvn.Level1>(
                                          value: value,
                                          child: Text(
                                              '${value.name} (${value.type.name})'),
                                        );
                                      }).toList();
                                    }(),
                                    validator: (_) =>
                                        controller.validateAddress(
                                            controller.addressController.text),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonFormField<dvhcvn.Level2>(
                                    decoration: const InputDecoration(
                                      labelText: 'District/County',
                                      labelStyle:
                                          TextStyle(color: Color(0xFF8E6C88)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.location_on,
                                        color: Color(0xFF8E6C88)),
                                    value: controller.selectedLevel2.value,
                                    onChanged:
                                        controller.selectedLevel1.value == null
                                            ? null
                                            : (dvhcvn.Level2? newValue) {
                                                if (newValue != null) {
                                                  controller.selectedLevel2
                                                      .value = newValue;
                                                }
                                              },
                                    items: controller.level2List
                                        .map<DropdownMenuItem<dvhcvn.Level2>>(
                                            (dvhcvn.Level2 value) {
                                      return DropdownMenuItem<dvhcvn.Level2>(
                                        value: value,
                                        child: Text(
                                            '${value.name} (${value.type.name})'),
                                      );
                                    }).toList(),
                                    validator: (_) =>
                                        controller.validateAddress(
                                            controller.addressController.text),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonFormField<dvhcvn.Level3>(
                                    decoration: const InputDecoration(
                                      labelText: 'Ward/Commune',
                                      labelStyle:
                                          TextStyle(color: Color(0xFF8E6C88)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.place,
                                        color: Color(0xFF8E6C88)),
                                    value: controller.selectedLevel3.value,
                                    onChanged:
                                        controller.selectedLevel2.value == null
                                            ? null
                                            : (dvhcvn.Level3? newValue) {
                                                if (newValue != null) {
                                                  controller.selectedLevel3
                                                      .value = newValue;
                                                }
                                              },
                                    items: controller.level3List
                                        .map<DropdownMenuItem<dvhcvn.Level3>>(
                                            (dvhcvn.Level3 value) {
                                      return DropdownMenuItem<dvhcvn.Level3>(
                                        value: value,
                                        child: Text(
                                            '${value.name} (${value.type.name})'),
                                      );
                                    }).toList(),
                                    validator: (_) =>
                                        controller.validateAddress(
                                            controller.addressController.text),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomTextFormField(
                                  controller:
                                      controller.streetAddressController,
                                  onSaved: (value) {
                                    controller.streetAddress.value = value!;
                                  },
                                  onChanged: (value) {
                                    controller.streetAddress.value = value!;
                                    controller.updateFullAddress();
                                  },
                                  validator: (_) => controller.validateAddress(
                                      controller.streetAddressController.text),
                                  hintTxt: 'Enter house number, street name',
                                  suffixIcon: const Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Color(0xFF8E6C88),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextFormField(
                                    controller:
                                        controller.dateOfBirthController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Date of Birth',
                                      labelStyle: const TextStyle(
                                        color: Color(0xFF8E6C88),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAD6E8C),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.calendar_today_rounded,
                                          color: Color(0xFF8E6C88),
                                        ),
                                        onPressed: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2101),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary: Color(0xFFAD6E8C),
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface:
                                                        Color(0xFF8E6C88),
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
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2101),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Color(0xFFAD6E8C),
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
                                    validator: (value) =>
                                        value == null || value == 'yyyy-MM-dd'
                                            ? 'Please select date of birth'
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Error message
                          Center(
                            child: Text(
                              controller.errorString.value,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[400],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 16),
                          Center(
                            child: controller.isLoading.value
                                ? Container(
                                    width: 220,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFAD6E8C), // Mauve/hồng đậm
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFAD6E8C)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        if (controller
                                            .registerFormKey.currentState!
                                            .validate()) {
                                          controller.isLoading.value = true;
                                          try {
                                            await controller
                                                .registerEmail(context);
                                          } finally {
                                            controller.isLoading.value = false;
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFFAD6E8C), // Mauve/hồng đậm
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor: const Color(0xFFAD6E8C)
                                            .withOpacity(0.4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: const Row(
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
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF8E6C88),
                                size: 18,
                              ),
                              label: const Text(
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
        ));
  }
}
