import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import '../models/subscription_plan_model.dart';
import '../models/user_subscription_model.dart';
import '../repositories/subscription_plan_repository.dart';
import '../repositories/user_subscription_repository.dart';
import '../util/app_export.dart';

class SubscriptionPlanDetailsController extends GetxController {
  var isLoading = false.obs;
  var subscriptionPlan = SubscriptionPlanModel().obs;
  Rx<UserSubscriptionModel> userSubscriptionModel = UserSubscriptionModel().obs;

  Timer? _paymentCheckTimer;
  var paymentStatus = "".obs;
  var isCheckingPayment = false.obs;

  @override
  void onInit() {
    // Nhận subscriptionPlanID từ Argument từ SubscriptionPlan screen
    int subscriptionPlanID = Get.arguments;

    getSubscriptionPlanByID(subscriptionPlanID);
    super.onInit();
  }

  @override
  void onClose() {
    _cancelPaymentCheckTimer();
    super.onClose();
  }

  Future<void> getSubscriptionPlanByID(int subscriptionPlanID) async {
    // gọi repository lấy thông tin subscription plan
    var response = await SubscriptionPlanRepository.getSubscriptionPlanDetail(
        subscriptionPlanID);
    if (response.statusCode == 200) {
      // chuyển dổi từ json sang subscriptionplan model
      String jsonResult = utf8.decode(response.bodyBytes);
      print("JSON Result: $jsonResult");

      subscriptionPlan.value =
          SubscriptionPlanModel.fromJson(json.decode(jsonResult));
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
  }

  Future<void> subscribesPlan() async {
    // Hiển thị loading dialog
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                ),
                SizedBox(height: 20),
                Text(
                  'Processing payment...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please wait while we prepare your payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible:
          false, // Không cho phép đóng dialog bằng cách nhấn bên ngoài
    );

    try {
      isLoading.value =
          true; // Đặt lại isLoading.value thay vì isLoading = true.obs
      // Tạo UserSubscriptionModel
      Map<String, dynamic> userSubscriptionRequest = {
        "subscriptionPlanId": subscriptionPlan.value.id,
        "amount": subscriptionPlan.value.price
      };

      print('tesst subscribes');
      var response = await UserSubscriptionRepository.makePayment(
          json.encode(userSubscriptionRequest));

      // Đóng dialog loading
      Get.back();

      // Log the response status and body
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        String jsonResult = utf8.decode(response.bodyBytes);
        // Log the JSON result
        print("JSON Result: $jsonResult");

        // get payment url
        String paymentUrl = jsonDecode(jsonResult)["paymentUrl"];

        Uri url = Uri.parse(paymentUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, webOnlyWindowName: '_self');

          // Lấy giá trị vnp_TxnRef từ URL
          String? vnpTxnRef = _extractVnpTxnRef(paymentUrl);
          print("vnp_TxnRef: $vnpTxnRef");

          if (vnpTxnRef != null) {
            // Hiển thị dialog thông báo về việc đợi
            Get.dialog(
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: 320,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 50,
                        color: Colors.blue[700],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Payment Processing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Please complete your payment in the opened window. Checking payment status in 10 seconds...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Get.back(); // Đóng dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text('OK, I understand'),
                      ),
                    ],
                  ),
                ),
              ),
              barrierDismissible:
                  true, // Cho phép đóng dialog bằng cách nhấn bên ngoài
            );

            // Delay 10 giây trước khi bắt đầu kiểm tra trạng thái thanh toán
            // print("Waiting 10 seconds before checking payment status...");
            // await _delay(10);
            print("Starting payment status check now");

            // Bắt đầu kiểm tra trạng thái thanh toán
            _startPaymentStatusCheck(vnpTxnRef);
          }
        } else {
          html.window.open(paymentUrl, '_self');
        }
      } else if (response.statusCode == 401) {
        String message = jsonDecode(response.body)['message'];
        if (message.contains("JWT token is expired")) {
          Get.snackbar('Session Expired', 'Please login again');
        }
      } else if (response.statusCode == 400) {
        String message = jsonDecode(response.body)['message'];

        // Kiểm tra nếu là thông báo "User already have an active subscription"
        if (message.contains("User already has an active subscription.")) {
          Get.dialog(
            AlertDialog(
              title: Text("Notification"),
              content: Text("You already have an active subscription."),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child:
                      Text("Close", style: TextStyle(color: Colors.green[700])),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar("Error server ${response.statusCode}", message);
        }
      } else if (response.statusCode == 403) {
        Get.snackbar(
            'Already subscribed', 'You have already subscribed a plan');
      } else {
        Get.snackbar("Error server ${response.statusCode}",
            jsonDecode(response.body)['message']);
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      if (Get.isDialogOpen!) {
        Get.back();
      }

      // Hiển thị thông báo lỗi
      Get.snackbar(
        'Error',
        'Failed to process payment: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );

      print('Error in subscribesPlan: $e');
    } finally {
      isLoading.value =
          false; // Đặt lại isLoading.value thay vì isLoading = false.obs
    }
  }

  // Phương thức để trích xuất vnp_TxnRef từ URL
  String? _extractVnpTxnRef(String url) {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> params = uri.queryParameters;
      return params['vnp_TxnRef'];
    } catch (e) {
      print("Error extracting vnp_TxnRef: $e");

      // Nếu Uri.parse không hoạt động, sử dụng cách thủ công
      RegExp regExp = RegExp(r'vnp_TxnRef=([^&]+)');
      Match? match = regExp.firstMatch(url);
      return match?.group(1);
    }
  }

  // Phương thức bắt đầu kiểm tra trạng thái thanh toán
  void _startPaymentStatusCheck(String txnRef) {
    // Hủy timer cũ nếu có
    _cancelPaymentCheckTimer();

    isCheckingPayment.value = true;

    // Tạo timer mới kiểm tra mỗi 3 giây
    _paymentCheckTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _checkPaymentStatus(txnRef);
      print("Starting payment status check now 3 seconds");
    });
  }

  // Hủy timer kiểm tra
  void _cancelPaymentCheckTimer() {
    _paymentCheckTimer?.cancel();
    _paymentCheckTimer = null;
    isCheckingPayment.value = false;
  }

  // Kiểm tra trạng thái thanh toán
  Future<void> _checkPaymentStatus(String txnRef) async {
    try {
      var response =
          await UserSubscriptionRepository.checkPaymentStatus(txnRef);
      print("Payment status check: ${response.body}");
      if (response.statusCode == 200) {
        print("Payment status check: ${response.body}");
        var data = json.decode(utf8.decode(response.bodyBytes));
        paymentStatus.value = data['status'] ?? '';

        print("Payment status check: ${paymentStatus.value}");

        // Nếu trạng thái là thành công hoặc thất bại
        if (paymentStatus.value == "PAYMENT_SUCCESS" ||
            paymentStatus.value == "PAYMENT_FAILED") {
          // Hủy timer
          _cancelPaymentCheckTimer();

          // Mở trang kết quả thanh toán
          _navigateToPaymentResult(paymentStatus.value, txnRef);
        }
      }
    } catch (e) {
      print("Error checking payment status: $e");
    }
  }

  // Điều hướng đến trang kết quả thanh toán
  void _navigateToPaymentResult(String status, String txnRef) {
    // Dừng kiểm tra
    _cancelPaymentCheckTimer();

    // Điều hướng dựa trên trạng thái thanh toán
    if (status == "PAYMENT_SUCCESS") {
      // Nếu thanh toán thành công, điều hướng đến trang thành công
      Get.toNamed(AppRoutes.paymentSuccess);
    } else if (status == "PAYMENT_FAILED") {
      // Nếu thanh toán thất bại, điều hướng đến trang thất bại
      Get.toNamed(AppRoutes.paymentFailed);
    } else {
      // Trường hợp khác, có thể hiển thị một thông báo
      Get.snackbar(
        "Payment Status",
        "Unknown payment status: $status",
        backgroundColor: Colors.amber[100],
        colorText: Colors.amber[800],
      );
    }
  }

  Future<void> _delay(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }
}
