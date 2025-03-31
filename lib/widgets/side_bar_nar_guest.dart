import 'package:flutter/material.dart';

import '../Onboarding/community_post_guest/community_post_guest_screen.dart';
import '../Onboarding/home_screen_guest.dart';
import '../Onboarding/subscription_plan/subscription_plan_guest.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';

class SideBarNavGuestScreen extends StatefulWidget {
  const SideBarNavGuestScreen({super.key});

  @override
  State<SideBarNavGuestScreen> createState() => _SideBarNavGuestScreenState();
}

class _SideBarNavGuestScreenState extends State<SideBarNavGuestScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const HomeScreenGuest(),
    // const BlogPostGuest(),
    const CommunityPostGuestScreen(),
    const SubscriptionPlanGuestScreen(),
    // AccountProfileScreen(),
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
                  Color(0xFFF8EEF6), // Hồng pastel nhạt
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
                      fontSize: 17,
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
                  label: Text('Community Post', style: TextStyle(fontSize: 15)),
                ),
                // NavigationRailDestination(
                //   icon: SizedBox(
                //     width: 24,
                //     child: Icon(Icons.person_outline),
                //   ),
                //   selectedIcon: SizedBox(
                //     width: 24,
                //     child: Icon(Icons.person),
                //   ),
                //   label:
                //       Text('Pregnancy Profile', style: TextStyle(fontSize: 15)),
                // ),
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
                // NavigationRailDestination(
                //   icon: SizedBox(
                //     width: 24,
                //     child: Icon(Icons.person_outline),
                //   ),
                //   selectedIcon: SizedBox(
                //     width: 24,
                //     child: Icon(Icons.person),
                //   ),
                //   label:
                //       Text('Account Profile', style: TextStyle(fontSize: 15)),
                // ),
              ],
              trailing: Padding(
                padding: const EdgeInsets.all(24.0),
                child:
                    // CustomElevatedButton(
                    //   onPressed: () {
                    //     // Gọi phương thức logout từ ManageUserController
                    //     Get.find<ManageUserController>().logOut();
                    //   },
                    //   text: 'Log out',
                    // ),
                    ElevatedButton(
                  onPressed: () async {
                    // Gọi phương thức logout từ ManageUserController
                    Get.toNamed(AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD6E8C), // Mauve/hồng đậm
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0xFFAD6E8C).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
