import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../util/app_export.dart';
import '../widgets/custom_elevated_button.dart';

class PregnancyProfileDetailsScreen extends StatelessWidget {
  // const PregnancyProfileScreen({super.key});
  final String nickname = 'Your Nickname';
  final DateTime dueDate = DateTime(2023, 12, 25);
  final DateTime conceptionDate = DateTime(2023, 3, 20);
  final int pregnancyWeek = 30;
  final String notes = 'These are some additional notes about the pregnancy.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Pregnancy Profile'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'PREGNANCY PROFILE',
              style: TextStyle(
                fontSize: 48, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 1000,
                  height: 500, // Adjust height as needed
                  child: Image.network(
                    'https://res.cloudinary.com/dlipvbdwi/image/upload/v1739408433/zwibz1obvawg6u8b7ck0.jpg', // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 600,
                  height: 300, // Adjust height as needed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SelectableText(
                        'Pregnancy',
                        style: TextStyle(
                          fontSize: 50, // Larger font size for the title
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20), // Space between title and content
                      SelectableText(
                        '''Welcome to pregnancy! This is the start of an incredible journey. To help you along, we offer info on pregnancy aches and pains, weight gain and nutrition, what's safe during pregnancy and what's not, pregnancy stages, labor and delivery, and more — plus how to sift through all those baby names to find the perfect one.''',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Nickname'),
                      subtitle: Text(nickname),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: SelectableText('Due Date'),
                      subtitle:
                          Text(dueDate.toLocal().toString().split(' ')[0]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Conception Date'),
                      subtitle: Text(
                          conceptionDate.toLocal().toString().split(' ')[0]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.pregnant_woman),
                      title: Text('Pregnancy Week'),
                      subtitle: Text('$pregnancyWeek weeks'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.note),
                      title: Text('Notes'),
                      subtitle: Text(notes),
                    ),
                  ),
                  SizedBox(height: 20), // Space before the button
                  SizedBox(
                    width: 200, // Adjust width as needed
                    height: 60, // Adjust height as needed
                    child: CustomElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.fetalgrowthstatistics);
                      },
                      text: 'Statistics',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
