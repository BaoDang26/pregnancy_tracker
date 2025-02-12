import 'package:get/get.dart';
import 'package:pregnancy_tracker/widgets/side_bar_nar.dart';

import '../home_screen/home_screen.dart';

class AppRoutes {
  static const String sidebarnar = '/sidebarnar';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';

  static List<GetPage> pages = [
    // GetPage(name: initialRoute, page: () => const InitialRoute()),
    GetPage(name: sidebarnar, page: () => SideBarNavScreen()),
    // GetPage(name: login, page: () => const LoginScreen()),
    // GetPage(name: signup, page: () => const SignupScreen()),
  ];
}
