import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';

import '../controllers/payment_success_controller.dart';
import '../util/app_export.dart';

class PaymentSuccessScreen extends GetView<PaymentSuccessController> {
  PaymentSuccessScreen({Key? key}) : super(key: key) {
    _confettiController = ConfettiController();
  }

  late final ConfettiController _confettiController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 230, 255, 230), // Background màu xanh lá nhạt
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon thành công
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                  const SizedBox(height: 24),

                  // Text thành công
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Text mô tả
                  Text(
                    'Your payment has been processed successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nút Back to Home
                  Obx(
                    () => controller.isPaymentSuccess.value
                        ? CustomElevatedButton(
                            text: 'Back to Home',
                            onPressed: () {
                              controller.goToHomeScreen();
                            },
                          )
                        : //Text thông báo trở về tab trước
                        Text(
                            'Back to previous tab to enable the features',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ), // Không hiển thị gì nếu isPaymentSuccess là false
                  ),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
          ),
        ],
      ),
    );
  }
}
