import 'package:get/get.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
// import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_edit_screen.dart';
import 'package:pregnancy_tracker/widgets/side_bar_nar.dart';

import '../Onboarding/subscription_plan/subscription_plan_detail.dart';
import '../account_profile/account_profile_screen.dart';
import '../fetal_growth_statistics/fetal_growth_statistics.dart';
import '../home_screen/home_screen.dart';
import '../login/login_screen.dart';
import '../register/register_screen.dart';

class AppRoutes {
  static const String sidebarnar = '/sidebarnar';
  static const String home = '/home';
  static const String pregnancyprofile = '/pregnancy-profile';
  static const String login = '/login';
  static const String register = '/register';
  static const String accountprofile = '/account-profile';
  static const String fetalgrowthstatistics = '/fetal-growth-statistics';
  static const String subscriptionplan = '/subscription-plan';
  static const String subscriptionplandetail = '/subscription-plan-detail';
  // static const String pregnancyprofileedit = '/pregnancy-profile-edit';
  // static const String signup = '/signup';

  static List<GetPage> pages = [
    // GetPage(name: initialRoute, page: () => const InitialRoute()),
    GetPage(name: sidebarnar, page: () => SideBarNavScreen()),
    GetPage(
        name: pregnancyprofile,
        page: () => PregnancyProfileScreen(),
        transition: Transition.noTransition),
    // GetPage(name: pregnancyprofileedit, page: () => PregnancyProfileEditScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: accountprofile, page: () => AccountProfileScreen()),
    GetPage(name: fetalgrowthstatistics, page: () => FetalGrowthStatistics()),
    GetPage(name: subscriptionplan, page: () => SubscriptionPlanDetailScreen()),
    GetPage(
        name: subscriptionplandetail,
        page: () => SubscriptionPlanDetailScreen()),
  ];
}
