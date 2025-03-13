import 'package:get/get.dart';

import '../controllers/community_post_controller.dart';

class CommunityPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityPostController());
  }
}
