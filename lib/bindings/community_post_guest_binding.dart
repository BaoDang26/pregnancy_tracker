import 'package:get/get.dart';

import '../controllers/community_post_guest_controller.dart';

class CommunityPostGuestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityPostGuestController());
  }
}
