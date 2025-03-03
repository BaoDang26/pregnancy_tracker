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
import '../SideBarNav/subscription_plan/subscription_plan_screen.dart';
import '../SideBarNav/subscription_plan/subscription_plan_details_screen.dart';
import '../SideBarNavSub/user_subscription/user_subscription_screen.dart';
import '../account_profile/account_profile_screen.dart';
import '../bindings/create_pregnancy_profile_binding.dart';
import '../bindings/fetal_growth_measurement_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/pregnancy_profile_details_binding.dart';
import '../bindings/register_binding.dart';
import '../bindings/subscription_plan_binding.dart';
import '../bindings/subscription_plan_details_binding.dart';
import '../bindings/user_subscription_binding.dart';
import '../bindings/user_subscription_details_binding.dart';
import '../create_pregnancy_profile/create_pregnancy_profile_screen.dart';
import '../fetal_growth_measurement/fetal_growth_measurement_screen.dart';
import '../login/login_screen.dart';

// import '../pregnancy_profile_details/pregnancy_profile_details.dart';
import '../payment/payment_failed_screen.dart';
import '../payment/payment_success_screen.dart';
import '../pregnancy_profile/pregnancy_profile_details.dart';
import '../register/register_screen.dart';
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

  // static const String pregnancyprofileedit = '/pregnancy-profile-edit';
  // static const String signup = '/signup';

  static List<GetPage> pages = [
    GetPage(
        name: usersubscription,
        page: () => UserSubscriptionScreen(),
        binding: UserSubscriptionBinding()),
    GetPage(
        name: createpregnancyprofile,
        page: () => CreatePregnancyProfileScreen(),
        binding: CreatePregnancyProfileBinding()),
    GetPage(name: pregnancyprofile, page: () => PregnancyProfileScreen()),
    GetPage(name: sidebarnarguest, page: () => SideBarNavGuestScreen()),
    GetPage(name: homeguest, page: () => HomeScreenGuest()),
    // GetPage(name: blogpostguest, page: () => BlogPostGuest()),
    GetPage(name: subscriptionplanguest, page: () => SubscriptionPlanGuest()),
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
    GetPage(name: accountprofile, page: () => AccountProfileScreen()),
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
