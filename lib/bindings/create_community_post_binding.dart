import 'package:get/get.dart';

import '../controllers/create_community_post_controller.dart';

class CreateCommunityPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateCommunityPostController());
  }
}
