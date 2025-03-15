import 'package:get/get.dart';

import '../controllers/community_post_guest_details_controller.dart';

class CommunityPostGuestDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityPostGuestDetailsController());
  }
}
