import 'package:flutter/material.dart';

import '../Onboarding/blog_post_guest/blog_post_guest.dart';
import '../Onboarding/home_screen_guest.dart';
import '../Onboarding/subscription_plan/subscription_plan_guest.dart';

class SideBarNavGuestScreen extends StatefulWidget {
  const SideBarNavGuestScreen({super.key});

  @override
  State<SideBarNavGuestScreen> createState() => _SideBarNavGuestScreenState();
}

class _SideBarNavGuestScreenState extends State<SideBarNavGuestScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const HomeScreenGuest(),
    const BlogPostGuest(),
    // PregnancyProfileScreen(),
    SubscriptionPlanGuestScreen(),
    // AccountProfileScreen(),
    // const HomeScreen(),
    // WeeklyMenuScreen(),
    // const AdvisorScreen(),
    // const ProfileScreen(),
    // const UpdateProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
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
                  Text(
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
