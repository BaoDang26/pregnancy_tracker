import 'package:get/get.dart';

import '../controllers/community_post_details_controller.dart';

class CommunityPostDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityPostDetailsController());
  }
}
