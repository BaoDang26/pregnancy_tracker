import 'package:pregnancy_tracker/controllers/pregnancy_profile_controller.dart';

import '../util/app_export.dart';

class SideBarNavBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Khởi tạo các controller
    Get.lazyPut(() => PregnancyProfileController());
    // Get.lazyPut(() => ProfileController());
    // Get.lazyPut(() => AdvisorController());

    // Khởi tạo dịch vụ Firebase Messaging và đăng ký với GetX
    // final firebaseMessagingService = FirebaseMessagingService();
    // await firebaseMessagingService.init();
    // Get.put(firebaseMessagingService);
  }
}
