import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/pregnancy_profile/pregnancy_profile_screen.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../Onboarding/blog_post_guest/blog_post_guest.dart';
import '../Onboarding/home_screen_guest.dart';
import '../Onboarding/subscription_plan/subscription_plan_guest.dart';
import 'custom_elevated_button.dart';

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
                  Color.fromARGB(255, 184, 239, 206),
                  Color.fromARGB(255, 176, 247, 194),
                  Color.fromARGB(255, 157, 234, 179),
                  Color.fromARGB(255, 139, 229, 164),
                  Color.fromARGB(255, 122, 224, 150),
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
              trailing: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  text: 'Login',
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
