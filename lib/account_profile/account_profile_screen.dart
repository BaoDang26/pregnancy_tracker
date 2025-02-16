import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

class AccountProfileScreen extends StatefulWidget {
  @override
  _AccountProfileScreenState createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dobController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Phần bên trái với Card
          Expanded(
            flex: 1,
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                          'https://res.cloudinary.com/dlipvbdwi/image/upload/v1700192116/avatar_snfpmg.jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tran Minh Hy',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Text('minhhy@gmail.com'),
                    SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: () {
                        // Logic để thay đổi hình ảnh
                      },
                      text: 'Upload Avatar',
                    ),
                    SizedBox(height: 20),
                    // Các nút điều hướng
                    // Column(
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         // Navigate to personal info
                    //       },
                    //       child: Text('Personal Info'),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         // Navigate to security settings
                    //       },
                    //       child: Text('Security Settings'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // Phần bên phải với Card
          Expanded(
            flex: 2,
            child: Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal Info', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 10),
                    // Chia thành 2 cột
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Full name'),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Tran Minh Hy',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Address'),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: '123 Main St, Anytown, USA',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20), // Khoảng cách giữa 2 cột
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('Role'),
                              // TextField(
                              //   decoration: InputDecoration(
                              //     hintText: 'Admin',
                              //     border: OutlineInputBorder(),
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              Text('Birthday'),
                              GestureDetector(
                                onTap: () =>
                                    _selectDate(context), // Mở lịch khi bấm
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: _dobController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Contact Info', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 10),
                    // Text('Phone'),
                    // TextField(
                    //   decoration: InputDecoration(
                    //     hintText: '0913658563',
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Text('Email'),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'minhhy@gmail.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: () {
                        // Logic để cập nhật thông tin
                      },
                      text: 'Update Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
