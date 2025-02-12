import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/subscription_plan.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Get.to(() => SubscriptionPlansScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          children: [
            // Image.network(
            //   'https://via.placeholder.com/50',
            //   height: 40,
            // ),
            SizedBox(width: 10),
            Text('Pregnancy Tracker',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            _buildNavItem('Home', 0),
            _buildNavItem('Subscription Plans', 1),
            _buildNavItem('Blogs', 2),
            _buildNavItem('Login', 3),
            SizedBox(width: 20),
            _buildIconItem(Icons.search, 4),
            SizedBox(width: 10),
            _buildIconItem(Icons.person, 5),
            SizedBox(width: 10),
            // _buildIconItem(Icons.shopping_cart, 6),
            // SizedBox(width: 10),
            // Text('0', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Center(
        child: Text('Content for selected page'),
      ),
    );
  }

  Widget _buildNavItem(String text, int index) {
    return TextButton(
      onPressed: () => _onItemTapped(index),
      child: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.yellow : Colors.white,
        ),
      ),
    );
  }

  Widget _buildIconItem(IconData icon, int index) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.yellow : Colors.white,
      ),
    );
  }
}
