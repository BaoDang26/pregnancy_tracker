import '../controllers/home_screen_guest_controller.dart';
import '../util/app_export.dart';

class HomeScreenGuestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeScreenGuestController());
  }
}
