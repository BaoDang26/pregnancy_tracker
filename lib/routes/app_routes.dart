import 'package:get/get.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
// import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_edit_screen.dart';
import 'package:pregnancy_tracker/widgets/side_bar_nar.dart';

import '../home_screen/home_screen.dart';

class AppRoutes {
  static const String sidebarnar = '/sidebarnar';
  static const String home = '/home';
  static const String pregnancyprofile = '/pregnancy-profile';
  // static const String pregnancyprofileedit = '/pregnancy-profile-edit';
  static const String signup = '/signup';

  static List<GetPage> pages = [
    // GetPage(name: initialRoute, page: () => const InitialRoute()),
    GetPage(name: sidebarnar, page: () => SideBarNavScreen()),
    GetPage(
        name: pregnancyprofile,
        page: () => PregnancyProfileScreen(),
        transition: Transition.noTransition),
    // GetPage(name: pregnancyprofileedit, page: () => PregnancyProfileEditScreen()),
    // GetPage(name: signup, page: () => const SignupScreen()),
  ];
}
