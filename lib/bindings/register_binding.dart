import '../controllers/register_controller.dart';
import '../util/app_export.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }
}
