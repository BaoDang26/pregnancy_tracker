import 'package:flutter/material.dart';

class SubscriptionPlanDetailGuestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Phần bên trái với gradient background
          Expanded(
            flex: 2,
            child: Container(
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Subscription Plan',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '150,000 VND\/month',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Unlocks unlimited Tab completions...',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // SwitchListTile(
                  //   title: Text(
                  //     'Tiết kiệm 48 US\$ với thanh toán hàng năm',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   value: false,
                  //   onChanged: (bool value) {},
                  //   activeColor: Colors.green,
                  // ),
                  SizedBox(height: 20),
                  Text(
                    'Tổng phụ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '20,00 US\$',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tổng tiền phải trả hôm nay',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '20,00 US\$',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          // Phần bên phải
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thanh toán bằng',
                    style: TextStyle(fontSize: 24),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text('Thẻ'),
                          value: 'card',
                          groupValue: 'paymentMethod',
                          onChanged: (value) {},
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text('Cash App Pay'),
                          value: 'cashApp',
                          groupValue: 'paymentMethod',
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Logic để đăng ký
                    },
                    child: Text('Đăng ký'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
