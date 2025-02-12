import 'package:flutter/material.dart';

import '../Onboarding/blog_post/blog_post_guest.dart';
import '../Onboarding/onboarding.dart';

class SideBarNavScreen extends StatefulWidget {
  const SideBarNavScreen({super.key});

  @override
  State<SideBarNavScreen> createState() => _SideBarNavScreenState();
}

class _SideBarNavScreenState extends State<SideBarNavScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = [
    const Onboarding(),
    const BlogPostGuest(),
    // const HomeScreen(),
    // WeeklyMenuScreen(),
    // const AdvisorScreen(),
    // const ProfileScreen(),
    // const UpdateProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Your App Title'),
      // ),
      body: Row(
        children: <Widget>[
          Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Onboarding'),
                  tileColor: _selectedIndex == 0
                      ? Colors.blueAccent
                      : Colors.transparent,
                  onTap: () {
                    _onItemTapped(0);
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.menu_book),
                //   title: Text('Weekly Menu'),
                //   onTap: () {
                //     _onItemTapped(1);
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.local_fire_department_rounded),
                  title: Text('Blog Post'),
                  tileColor: _selectedIndex == 1
                      ? Colors.blueAccent
                      : Colors.transparent,
                  onTap: () {
                    _onItemTapped(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                  onTap: () {
                    _onItemTapped(2);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
