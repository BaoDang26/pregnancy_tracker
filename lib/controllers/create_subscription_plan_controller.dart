import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/subscription_plan_repository.dart';
import 'manage_subscription_plan_controller.dart';

class CreateSubscriptionPlanController extends GetxController {
  final GlobalKey<FormState> subscriptionPlanFormKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController durationController;
  late TextEditingController descriptionController;

  var subscriptionPlanModel = SubscriptionPlanModel().obs;
  var isLoading = false.obs;
  var errorString = ''.obs;
  var name = '';
  var price = '';
  var duration = '';
  var description = '';

  @override
  void onInit() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    durationController = TextEditingController();
    descriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan name';
    }
    return null;
  }

  String? validatePrice(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan price';
    }

    // Check if the input is a valid number
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for the price';
    }

    return null;
  }

  String? validateDuration(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan duration';
    }

    // Check if the input is a valid number
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number for the duration';
    }

    return null;
  }

  String? validateDescription(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan description';
    }
    return null;
  }

  Future<void> createSubscriptionPlan() async {
    isLoading.value = true;

    final isValid = subscriptionPlanFormKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return;
    }
    subscriptionPlanFormKey.currentState!.save();

    // Tạo SubscriptionPlanModel
    SubscriptionPlanModel subscriptionPlanModel = SubscriptionPlanModel(
      name: name,
      price: double.parse(price),
      duration: int.parse(duration),
      description: description,
    );

    var response = await SubscriptionPlanRepository.createSubscriptionPlan(
        subscriptionPlanModel);
    if (response.statusCode == 200) {
      Get.back();
      Get.snackbar(
        'Success',
        'Subscription plan created successfully',
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      nameController.clear();
      priceController.clear();
      durationController.clear();
      descriptionController.clear();

      Get.find<ManageSubscriptionPlanController>().getSubscriptionPlanList();
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }
}
