import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admin/manage_subscription_plan_screen.dart';
import '../admin/manage_user_screen.dart';
import 'custom_elevated_button.dart';

class SideBarNavAdmin extends StatefulWidget {
  const SideBarNavAdmin({super.key});

  @override
  State<SideBarNavAdmin> createState() => _SideBarNavAdminState();
}

class _SideBarNavAdminState extends State<SideBarNavAdmin> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const ManageUserScreen(),
    const ManageSubscriptionPlanScreen(),
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
                    child: Icon(Icons.person_outline),
                  ),
                  selectedIcon: SizedBox(
                    width: 24,
                    child: Icon(Icons.person),
                  ),
                  label: Text('User', style: TextStyle(fontSize: 15)),
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
