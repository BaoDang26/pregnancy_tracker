import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'app_export.dart';

class InitialBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(PrefUtils());
    // Khởi tạo Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
