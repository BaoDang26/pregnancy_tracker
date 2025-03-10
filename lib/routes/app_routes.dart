import 'package:get/get.dart';
import 'package:pregnancy_tracker/bindings/side_bar_nav_binding.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';

// import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_edit_screen.dart';
import 'package:pregnancy_tracker/widgets/side_bar_nar.dart';

import '../Onboarding/blog_post_guest/blog_post_detail_guest.dart';
import '../Onboarding/blog_post_guest/blog_post_guest.dart';
import '../Onboarding/home_screen_guest.dart';
import '../Onboarding/subscription_plan/subscription_plan_detail_guest.dart';
import '../Onboarding/subscription_plan/subscription_plan_guest.dart';
import '../SideBarNav/blog_post/blog_post.dart';
import '../SideBarNav/blog_post/blog_post_detail.dart';
import '../SideBarNav/home_screen.dart';
import '../SideBarNav/subscription_plan/subscription_plan_screen.dart';
import '../SideBarNav/subscription_plan/subscription_plan_details_screen.dart';
import '../SideBarNavSub/user_subscription/user_subscription_screen.dart';
import '../account_profile/account_profile_screen.dart';
import '../account_profile/update_account_profile_screen.dart';
import '../bindings/account_profile_binding.dart';
import '../bindings/create_fetal_growth_measurement_binding.dart';
import '../bindings/create_pregnancy_profile_binding.dart';
import '../bindings/create_schedule_binding.dart';
import '../bindings/fetal_growth_measurement_binding.dart';
import '../bindings/home_screen_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/pregnancy_profile_details_binding.dart';
import '../bindings/register_binding.dart';
import '../bindings/schedule_binding.dart';
import '../bindings/side_bar_nav_guest_binding.dart';
import '../bindings/subscription_plan_binding.dart';
import '../bindings/subscription_plan_details_binding.dart';
import '../bindings/subscription_plan_guest_binding.dart';
import '../bindings/update_account_profile_binding.dart';
import '../bindings/update_fetal_growth_measurement_binding.dart';
import '../bindings/update_schedule_binding.dart';
import '../bindings/user_subscription_binding.dart';
import '../bindings/user_subscription_details_binding.dart';
import '../create_fetal_growth_measurement/create_fetal_growth_measurement_screen.dart';
import '../create_pregnancy_profile/create_pregnancy_profile_screen.dart';
import '../fetal_growth_measurement/fetal_growth_measurement_screen.dart';
import '../login/login_screen.dart';

// import '../pregnancy_profile_details/pregnancy_profile_details.dart';
import '../payment/payment_failed_screen.dart';
import '../payment/payment_success_screen.dart';
import '../pregnancy_profile/pregnancy_profile_details_screen.dart';
import '../register/register_screen.dart';
import '../schedule/create_schedule_screen.dart';
import '../schedule/schedule_screen.dart';
import '../schedule/update_schedule_screen.dart';
import '../update_fetal_growth_measurement/update_fetal_growth_measurement_screen.dart';
import '../widgets/side_bar_nar_guest.dart';

class AppRoutes {
  static const String pregnancyprofile = '/pregnancy-profile';
  static const String sidebarnar = '/sidebarnar';
  static const String home = '/home';
  static const String pregnancyprofiledetails = '/pregnancy-profile-details';
  static const String login = '/login';
  static const String register = '/register';
  static const String accountprofile = '/account-profile';
  static const String fetalgrowthstatistics = '/fetal-growth-statistics';
  static const String subscriptionplan = '/subscription-plan';
  static const String subscriptionplandetail = '/subscription-plan-detail';
  static const String blogpost = '/blog-post';
  static const String blogpostdetail = '/blog-post-detail';
  static const String blogpostdetailguest = '/blog-post-detail-guest';
  static const String blogpostguest = '/blog-post-guest';
  static const String subscriptionplandetailguest =
      '/subscription-plan-detail-guest';
  static const String subscriptionplanguest = '/subscription-plan-guest';
  static const String homeguest = '/home-guest';
  static const String sidebarnarguest = '/sidebarnar-guest';
  static const String createpregnancyprofile = '/create-pregnancy-profile';
  static const String fetalgrowthmeasurement = '/fetal-growth-measurement';
  static const String usersubscription = '/user-subscription';
  static const String paymentSuccess = '/payment-success';
  static const String paymentFailed = '/payment-failed';
  static const String createfetalgrowthmeasurement =
      '/create-fetal-growth-measurement';
  static const String updatefetalgrowthmeasurement =
      '/update-fetal-growth-measurement';
  static const String schedule = '/schedule';
  static const String createSchedule = '/create-schedule';
  static const String updateSchedule = '/update-schedule';
  static const String updateAccountProfile = '/update-account-profile';

  // static const String pregnancyprofileedit = '/pregnancy-profile-edit';
  // static const String signup = '/signup';

  static List<GetPage> pages = [
    GetPage(
        name: updateAccountProfile,
        page: () => UpdateAccountProfileScreen(),
        binding: UpdateAccountProfileBinding()),
    GetPage(name: home, page: () => HomeScreen(), binding: HomeScreenBinding()),
    GetPage(
        name: updateSchedule,
        page: () => UpdateScheduleScreen(),
        binding: UpdateScheduleBinding()),
    GetPage(
        name: createSchedule,
        page: () => CreateScheduleScreen(),
        binding: CreateScheduleBinding()),
    GetPage(
        name: schedule,
        page: () => ScheduleScreen(),
        binding: ScheduleBinding()),
    GetPage(
        name: updatefetalgrowthmeasurement,
        page: () => UpdateFetalGrowthMeasurementScreen(),
        binding: UpdateFetalGrowthMeasurementBinding()),
    GetPage(
        name: createfetalgrowthmeasurement,
        page: () => CreateFetalGrowthMeasurementScreen(),
        binding: CreateFetalGrowthMeasurementBinding()),
    GetPage(
        name: usersubscription,
        page: () => UserSubscriptionScreen(),
        binding: UserSubscriptionBinding()),
    GetPage(
        name: createpregnancyprofile,
        page: () => CreatePregnancyProfileScreen(),
        binding: CreatePregnancyProfileBinding()),
    GetPage(name: pregnancyprofile, page: () => PregnancyProfileScreen()),
    GetPage(
        name: sidebarnarguest,
        page: () => SideBarNavGuestScreen(),
        binding: SideBarNavGuestBinding()),
    GetPage(name: homeguest, page: () => HomeScreenGuest()),
    // GetPage(name: blogpostguest, page: () => BlogPostGuest()),
    GetPage(
        name: subscriptionplanguest,
        page: () => SubscriptionPlanGuestScreen(),
        binding: SubscriptionPlanGuestBinding()),
    GetPage(
        name: subscriptionplandetailguest,
        page: () => SubscriptionPlanDetailGuestScreen()),

    // GetPage(name: initialRoute, page: () => const InitialRoute()),
    GetPage(
        name: sidebarnar,
        page: () => SideBarNavScreen(),
        binding: SideBarNavBinding()),
    GetPage(
        name: pregnancyprofiledetails,
        page: () => PregnancyProfileDetailsScreen(),
        binding: PregnancyProfileDetailsBinding(),
        transition: Transition.noTransition),
    // GetPage(name: pregnancyprofileedit, page: () => PregnancyProfileEditScreen()),
    GetPage(name: login, page: () => LoginScreen(), binding: LoginBinding()),
    GetPage(
        name: register,
        page: () => RegisterScreen(),
        binding: RegisterBinding()),
    GetPage(
        name: accountprofile,
        page: () => AccountProfileScreen(),
        binding: AccountProfileBinding()),
    GetPage(
        name: fetalgrowthmeasurement,
        page: () => FetalGrowthMeasurementScreen(),
        binding: FetalGrowthMeasurementBinding()),
    GetPage(
        name: subscriptionplan,
        page: () => SubscriptionPlan(),
        binding: SubscriptionPlanBinding()),
    GetPage(
        name: subscriptionplandetail,
        page: () => SubscriptionPlanDetailScreen(),
        binding: SubscriptionPlanDetailsBinding()),
    GetPage(
        name: blogpostdetail,
        page: () => BlogPostDetail(
              title: 'Blog Title',
              content: 'This is a content',
              imageUrl:
                  'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896652/cld-sample-4.jpg',
              commentCount: 3,
              comments: [
                {
                  'userName': 'John Doe',
                  'content': 'This is a comment',
                },
                {
                  'userName': 'Jane Doe2',
                  'content': 'This is a comment2',
                },
              ],
            )),
    GetPage(
        name: blogpostdetailguest,
        page: () => BlogPostDetailGuest(
              title: 'Blog Title',
              content: 'This is a content',
              imageUrl:
                  'https://res.cloudinary.com/dlipvbdwi/image/upload/v1696896652/cld-sample-4.jpg',
              commentCount: 3,
              comments: [
                {
                  'userName': 'John Doe',
                  'content': 'This is a comment',
                },
                {
                  'userName': 'Jane Doe2',
                  'content': 'This is a comment2',
                },
              ],
            )),
    GetPage(
      name: paymentSuccess,
      page: () => PaymentSuccessScreen(),
      // binding: PaymentSuccessBinding()),
    ),
    GetPage(
      name: paymentFailed,
      page: () => PaymentFailedScreen(),
      // binding: PaymentFailedBinding()),
    ),
  ];
}
