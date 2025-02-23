import 'package:flutter/material.dart';

import '../controllers/pregnancy_profile_details_controller.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';
import '../widgets/custom_elevated_button.dart';

class PregnancyProfileDetailsScreen
    extends GetView<PregnancyProfileDetailsController> {
  const PregnancyProfileDetailsScreen({super.key});

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
                      subtitle: Text(
                          controller.pregnancyProfileModel.value.nickName ??
                              ''),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: SelectableText('Due Date'),
                      subtitle: Text(controller
                              .pregnancyProfileModel.value.dueDate
                              ?.format() ??
                          ''),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Conception Date'),
                      subtitle: Text(controller
                              .pregnancyProfileModel.value.conceptionDate
                              ?.format() ??
                          ''),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.pregnant_woman),
                      title: Text('Pregnancy Week'),
                      subtitle: Text(
                          '${controller.pregnancyProfileModel.value.pregnancyWeek} weeks'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.note),
                      title: Text('Notes'),
                      subtitle: Text(
                          controller.pregnancyProfileModel.value.notes ?? ''),
                    ),
                  ),
                  SizedBox(height: 20), // Space before the button
                  SizedBox(
                    width: 200, // Adjust width as needed
                    height: 60, // Adjust height as needed
                    child: CustomElevatedButton(
                      onPressed: () {
                        controller.goToFetalGrowthMeasurement();
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
