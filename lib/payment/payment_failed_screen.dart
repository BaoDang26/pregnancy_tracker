import 'package:flutter/material.dart';
import '../util/app_export.dart';
import '../widgets/custom_elevated_button.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PaymentFailedScreen");
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 235, 235), // Background màu đỏ nhạt
      body: Center(
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
              // Icon thất bại
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              const SizedBox(height: 24),

              // Text thất bại
              const Text(
                'Payment Failed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),

              // Text mô tả
              Text(
                'Your payment could not be processed.\nPlease try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Hai nút: Try Again và Back to Home
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nút Try Again
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Xử lý khi nhấn thử lại
                  //     Get.back(); // Quay lại màn hình thanh toán
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.red,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     'Try Again',
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 16), // Khoảng cách giữa 2 nút

                  // Nút Back to Home
                  CustomElevatedButton(
                    text: 'Back to Home',
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.sidebarnar);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
