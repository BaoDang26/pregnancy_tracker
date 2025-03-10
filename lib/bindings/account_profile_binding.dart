import '../controllers/account_profile_controller.dart';
import '../util/app_export.dart';

class AccountProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountProfileController());
  }
}
