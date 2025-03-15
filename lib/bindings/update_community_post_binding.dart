import 'package:get/get.dart';
import '../controllers/update_community_post_controller.dart';

class UpdateCommunityPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateCommunityPostController());
  }
}
