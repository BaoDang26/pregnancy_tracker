import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/routes/app_routes.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import '../register/register_screen.dart'; // Import the signup screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 164, 219, 186),
                    Color.fromARGB(255, 156, 227, 184),
                    Color.fromARGB(255, 137, 214, 169),
                    Color.fromARGB(255, 119, 209, 154),
                    Color.fromARGB(255, 102, 204, 140),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pregnancy Tracker',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 24),
                  ),
                  const Text(
                    'Please enter your details',
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        // Handle login action
                        Get.toNamed(AppRoutes.sidebarnar);
                      },
                      text: 'Login',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: const Text(
                        'If you don\'t have an account, please sign up'),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      text: 'Sign Up',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  // const Text(
                  //   'Join the millions of smart investors who trust us to manage their finances.',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 12),
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/logo.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
