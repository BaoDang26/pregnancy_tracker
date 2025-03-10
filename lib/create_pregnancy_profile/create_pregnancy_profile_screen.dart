import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../controllers/create_pregnancy_profile_controller.dart';
import '../widgets/custom_elevated_button.dart';

class CreatePregnancyProfileScreen
    extends GetView<CreatePregnancyProfileController> {
  const CreatePregnancyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: appTheme.white,
          body: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appTheme.green500),
            ),
          ),
        );
      }
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
                child: Form(
                  key: controller.pregnancyProfileFormKey,
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
                      TextFormField(
                        controller: controller.nickNameController,
                        onSaved: (value) {
                          controller.nickName = value!;
                        },
                        validator: (value) {
                          return controller.validateNickName(value!);
                        },
                        decoration: InputDecoration(
                          labelText: 'Baby\'s nickname',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose one option:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              title: Text('Enter Last Period Date'),
                              subtitle: Text('We will calculate your due date'),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 280)),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors.green,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  String formattedLPD = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  controller.lastPeriodDateController.text =
                                      formattedLPD;

                                  DateTime dueDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month + 9,
                                    pickedDate.day + 7,
                                  );

                                  if (pickedDate.month + 9 > 12) {
                                    dueDate = DateTime(
                                      pickedDate.year + 1,
                                      (pickedDate.month + 9) - 12,
                                      pickedDate.day + 7,
                                    );
                                  }

                                  controller.dueDateController.text =
                                      DateFormat('yyyy-MM-dd').format(dueDate);
                                }
                              },
                              leading: Icon(Icons.calendar_today,
                                  color: Colors.green),
                              tileColor: controller
                                      .lastPeriodDateController.text.isNotEmpty
                                  ? Colors.green.withOpacity(0.1)
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              title: Text('Enter Due Date'),
                              subtitle: Text(
                                  'If you already know your due date from doctor'),
                              onTap: () async {
                                DateTime now = DateTime.now();
                                DateTime minDate = now.add(Duration(days: 1));
                                DateTime maxDate = now.add(Duration(days: 280));

                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: minDate,
                                  firstDate: minDate,
                                  lastDate: maxDate,
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors.green,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  controller.dueDateController.text =
                                      formattedDate;

                                  DateTime lastPeriodDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month - 9,
                                    pickedDate.day - 7,
                                  );

                                  if (pickedDate.month - 9 < 1) {
                                    lastPeriodDate = DateTime(
                                      pickedDate.year - 1,
                                      12 + (pickedDate.month - 9),
                                      pickedDate.day - 7,
                                    );
                                  }

                                  controller.lastPeriodDateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(lastPeriodDate);
                                }
                              },
                              leading: Icon(Icons.event, color: Colors.green),
                              tileColor: controller
                                          .dueDateController.text.isNotEmpty &&
                                      controller
                                          .lastPeriodDateController.text.isEmpty
                                  ? Colors.green.withOpacity(0.1)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.lastPeriodDateController,
                        onSaved: (value) {
                          controller.lastPeriodDate = value!;
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Last Period Date',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.dueDateController,
                        onSaved: (value) {
                          controller.dueDate = value!;
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter any additional notes here...',
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (controller.lastPeriodDateController.text.isNotEmpty ||
                          controller.dueDateController.text.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Pregnancy Dates',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Last Period Date:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(controller
                                            .lastPeriodDateController.text),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Due Date:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller.dueDateController.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (controller.pregnancyProfileFormKey.currentState!
                                .validate()) {
                              controller.pregnancyProfileFormKey.currentState!
                                  .save();
                              await controller.createPregnancyProfile();
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return Dialog(
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(12),
                              //       ),
                              //       child: Container(
                              //         padding: EdgeInsets.all(20),
                              //         child: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             Text(
                              //               'Success',
                              //               style: TextStyle(
                              //                 fontSize: 24,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //             SizedBox(height: 10),
                              //             Text('Profile created successfully!'),
                              //             SizedBox(height: 20),
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //               child: Text('OK'),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );
                            }
                          },
                          text: 'Create Profile',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
