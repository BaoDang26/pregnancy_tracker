import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:get/get.dart';

import '../SideBarNav/home_screen.dart';
import '../SideBarNavSub/community_post/community_post_screen.dart';
import '../account_profile/account_profile_screen.dart';

import 'custom_elevated_button.dart';
import '../SideBarNav/subscription_plan/subscription_plan_screen.dart';

class SideBarNavScreen extends StatefulWidget {
  const SideBarNavScreen({super.key});

  @override
  State<SideBarNavScreen> createState() => _SideBarNavScreenState();
}

class _SideBarNavScreenState extends State<SideBarNavScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const CommunityPostScreen(),
    const PregnancyProfileScreen(),
    const SubscriptionPlan(),
    const AccountProfileScreen(),
    // const HomeScreen(),
    // WeeklyMenuScreen(),
    // const AdvisorScreen(),
    // const ProfileScreen(),
    // const UpdateProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // Đợi đến khi widget được build hoàn chỉnh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Nhận tham số và cập nhật selectedIndex
      if (Get.arguments != null && Get.arguments is Map) {
        final args = Get.arguments as Map;
        if (args.containsKey('selectedIndex')) {
          setState(() {
            _selectedIndex = args['selectedIndex'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF8EEF6), // Hồng pastel nhạt
                  Color(0xFFF5E1EB), // Hồng pastel
                  Color(0xFFEBD7E6), // Hồng nhạt pha tím
                  Color(0xFFE5D1E8), // Tím lavender nhạt
                  Color(0xFFDBC5DE), // Tím lavender đậm hơn một chút
                ],
              ),
            ),
            child: NavigationRail(
              minWidth: 100,
              elevation: 10,
              extended: true,
              backgroundColor: Colors.transparent,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: Row(
                children: [
                  Image.asset(
                    'assets/images/logo-removebg-preview.png',
                    height: 85,
                  ),
                  // SizedBox(width: 8),
                  const Text(
                    'Pregnancy Tracker',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: SizedBox(
                    width: 24,
                    child: Icon(Icons.home_outlined),
                  ),
                  selectedIcon: SizedBox(
                    width: 24,
                    child: Icon(Icons.home),
                  ),
                  label: Text('Home', style: TextStyle(fontSize: 15)),
                ),
                NavigationRailDestination(
                  icon: SizedBox(
                    width: 24,
                    child: Icon(Icons.local_fire_department_outlined),
                  ),
                  selectedIcon: SizedBox(
                    width: 24,
                    child: Icon(Icons.local_fire_department),
                  ),
                  label: Text('Blog Post', style: TextStyle(fontSize: 15)),
                ),
                NavigationRailDestination(
                  icon: SizedBox(
                    width: 24,
                    child: Icon(Icons.person_outline),
                  ),
                  selectedIcon: SizedBox(
                    width: 24,
                    child: Icon(Icons.person),
                  ),
                  label:
                      Text('Pregnancy Profile', style: TextStyle(fontSize: 15)),
                ),
                NavigationRailDestination(
                  icon: SizedBox(
                    width: 24,
                    child: Icon(Icons.shopify),
                  ),
                  selectedIcon: SizedBox(
                    width: 24,
                    child: Icon(Icons.shopify_outlined),
                  ),
                  label:
                      Text('Subscription Plan', style: TextStyle(fontSize: 15)),
                ),
                NavigationRailDestination(
                  icon: SizedBox(
                    width: 24,
                    child: Icon(Icons.person_outline),
                  ),
                  selectedIcon: SizedBox(
                    width: 24,
                    child: Icon(Icons.person),
                  ),
                  label:
                      Text('Account Profile', style: TextStyle(fontSize: 15)),
                ),
              ],
              // trailing: Padding(
              //   padding: const EdgeInsets.all(24.0),
              //   child: CustomElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, AppRoutes.login);
              //     },
              //     text: 'Log out',
              //   ),
              // ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: _widgetOptions[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
