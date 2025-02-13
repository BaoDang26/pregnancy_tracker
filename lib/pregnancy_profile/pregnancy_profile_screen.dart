import 'package:flutter/material.dart';

class PregnancyProfileScreen extends StatelessWidget {
  final String nickname = 'Your Nickname';
  final DateTime dueDate = DateTime(2023, 12, 25);
  final DateTime conceptionDate = DateTime(2023, 3, 20);
  final int pregnancyWeek = 30;
  final String notes = 'These are some additional notes about the pregnancy.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pregnancy Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100, vertical: 30), // Adjust padding
                      textStyle: TextStyle(fontSize: 20), // Adjust font size
                    ),
                    child: Text('Statistics'),
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
