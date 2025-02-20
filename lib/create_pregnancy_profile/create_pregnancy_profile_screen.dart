import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../widgets/custom_elevated_button.dart';

class CreatePregnancyProfileScreen extends StatefulWidget {
  @override
  _CreatePregnancyProfileScreenState createState() =>
      _CreatePregnancyProfileScreenState();
}

class _CreatePregnancyProfileScreenState
    extends State<CreatePregnancyProfileScreen> {
  final TextEditingController _dobController = TextEditingController();
  bool _isPasswordVisible = false; // Nếu cần thiết, có thể thêm trường mật khẩu
  bool _isConfirmPasswordVisible =
      false; // Nếu cần thiết, có thể thêm trường xác nhận mật khẩu

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
                    'Create Pregnancy Profile',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please enter your details',
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nick name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Week of pregnancy',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // // ... existing code for password fields if needed ...
                  // const SizedBox(height: 16),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Address',
                  //     border: OutlineInputBorder(),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _dobController.text =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Conception date',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _dobController.text =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Due date',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        // Hiển thị thông báo pop-up khi tạo hồ sơ thành công
                        Get.toNamed(AppRoutes.pregnancyprofile);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Success',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Profile created successfully!'),
                                    SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Đóng hộp thoại
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      text: 'Create Profile',
                    ),
                  ),
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
