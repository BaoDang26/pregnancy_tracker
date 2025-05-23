import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

class SubscriptionPlanDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Phần bên trái với gradient background
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 164, 219, 186),
                    const Color.fromARGB(255, 156, 227, 184),
                    Color.fromARGB(255, 137, 214, 169),
                    Color.fromARGB(255, 119, 209, 154),
                    Color.fromARGB(255, 102, 204, 140),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: const Column(
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
                    'Unlocks unlimited Tab completions and additional features for a seamless experience.',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total price',
                    style: TextStyle(color: Colors.white),
                  ),
                  // SizedBox(height: 20),
                  Text(
                    '150,000 VND  \n30 days',
                    style: TextStyle(color: Colors.white, fontSize: 32),
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

                  // Text(
                  //   '20,00 US\$',
                  //   style: TextStyle(color: Colors.white, fontSize: 24),
                  // ),
                  // SizedBox(height: 20),
                  // Text(
                  //   'Tổng tiền phải trả hôm nay',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  // Text(
                  //   '20,00 US\$',
                  //   style: TextStyle(color: Colors.white, fontSize: 24),
                  // ),
                ],
              ),
            ),
          ),
          // Phần bên phải
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment method',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: NetworkImage(
                                  'https://res.cloudinary.com/dlipvbdwi/image/upload/v1740010783/VNPay.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'VNPay',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    onPressed: () {
                      // Logic để đăng ký
                    },
                    text: 'Subscribe',
                    // backgroundColor: Colors.blue,
                    // padding: EdgeInsets.symmetric(vertical: 16.0),
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
