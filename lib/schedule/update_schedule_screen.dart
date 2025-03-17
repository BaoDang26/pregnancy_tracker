import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/update_schedule_controller.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

class UpdateScheduleScreen extends GetView<UpdateScheduleController> {
  const UpdateScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFCE4EC), // Hồng nhạt
              Color(0xFFE1F5FE), // Xanh da trời nhạt
              Color(0xFFE8F5E9), // Xanh lá nhạt
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Update Prenatal Check-up",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Modify your appointment details",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Main Content - Form and Info
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Form
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Obx(() => controller.isLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.purple[600]))
                              : Form(
                                  key: controller.scheduleFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Form Title
                                      Row(
                                        children: [
                                          Icon(Icons.event_note,
                                              color: Colors.purple[600],
                                              size: 28),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Appointment Details",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                          thickness: 1,
                                          color:
                                              Colors.purple.withOpacity(0.2)),
                                      const SizedBox(height: 20),

                                      // Title Field
                                      Text(
                                        "Appointment Title",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: controller.titleController,
                                        validator: (value) => controller
                                            .validateTitle(value ?? ""),
                                        decoration: InputDecoration(
                                          hintText:
                                              "E.g., Week 20 Ultrasound Check-up",
                                          prefixIcon: Icon(Icons.title,
                                              color: Colors.purple[300]),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.purple[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.purple[600]!,
                                                width: 2),
                                          ),
                                          fillColor: Colors.grey[50],
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Date Field
                                      Text(
                                        "Appointment Date",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller:
                                            controller.eventDateController,
                                        validator: (value) => controller
                                            .validateEventDate(value ?? ""),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText: "YYYY-MM-DD",
                                          prefixIcon: Icon(Icons.calendar_today,
                                              color: Colors.purple[300]),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.calendar_month,
                                                color: Colors.purple[600]),
                                            onPressed: () =>
                                                controller.showDatePicker(),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.purple[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.purple[600]!,
                                                width: 2),
                                          ),
                                          fillColor: Colors.grey[50],
                                          filled: true,
                                        ),
                                        onTap: () =>
                                            controller.showDatePicker(),
                                      ),
                                      const SizedBox(height: 24),

                                      // Description Field
                                      Text(
                                        "Appointment Description",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller:
                                            controller.descriptionController,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Additional details about your appointment...",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 80),
                                            child: Icon(Icons.description,
                                                color: Colors.purple[300]),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.purple[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Colors.purple[600]!,
                                                width: 2),
                                          ),
                                          fillColor: Colors.grey[50],
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(height: 30),

                                      // Error message display
                                      Obx(() => controller
                                              .errorMessage.value.isNotEmpty
                                          ? Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.red[50],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.red[300]!),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      controller
                                                          .errorMessage.value,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red[700]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink()),
                                      const SizedBox(height: 10),

                                      // Buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Cancel Button
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Get.back(),
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                side: BorderSide(
                                                    color: Colors.purple[300]!),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.purple[700],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),

                                          // Delete Button
                                          // Expanded(
                                          //   child: OutlinedButton(
                                          //     onPressed: () => controller
                                          //         .showDeleteConfirmation(),
                                          //     style: OutlinedButton.styleFrom(
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //               vertical: 16),
                                          //       side: BorderSide(
                                          //           color: Colors.red[300]!),
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(10),
                                          //       ),
                                          //     ),
                                          //     child: Row(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.center,
                                          //       children: [
                                          //         Icon(Icons.delete_outline,
                                          //             color: Colors.red[700]),
                                          //         const SizedBox(width: 8),
                                          //         Text(
                                          //           "Delete",
                                          //           style: TextStyle(
                                          //             fontSize: 16,
                                          //             color: Colors.red[700],
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(width: 16),

                                          // Update Button
                                          Expanded(
                                            flex: 2,
                                            child: Obx(() => ElevatedButton(
                                                  onPressed:
                                                      controller.isLoading.value
                                                          ? null
                                                          : () => controller
                                                              .updateSchedule(),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    backgroundColor:
                                                        Colors.purple[600],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    elevation: 2,
                                                  ),
                                                  child: controller
                                                          .isLoading.value
                                                      ? const CircularProgressIndicator(
                                                          color: Colors.white)
                                                      : const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .white),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              "Update Appointment",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                        ),
                      ),

                      // Right side - Info and Image
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Image Container
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Image.network(
                                      'https://res.cloudinary.com/dlipvbdwi/image/upload/v1741174708/jowghg72mdvrrxnvfih2.png',
                                      height: 240,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Keep your appointment details up-to-date",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.purple[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Info Container
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recommended Check-up Schedule",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple[800],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCheckupItem(
                                      "Weeks 4-28",
                                      "One prenatal visit a month",
                                      Icons.event_repeat,
                                    ),
                                    _buildCheckupItem(
                                      "Weeks 28-36",
                                      "One prenatal visit every two weeks",
                                      Icons.event_repeat,
                                    ),
                                    _buildCheckupItem(
                                      "Weeks 36-birth",
                                      "One prenatal visit every week",
                                      Icons.event_repeat,
                                    ),
                                    _buildCheckupItem(
                                      "Important scans",
                                      "Weeks 8-12 (dating), 18-22 (anatomy)",
                                      Icons.calendar_view_month,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Tips Container
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tips for Your Appointment",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTipItem(
                                      "Prepare questions for your doctor",
                                      Icons.help_outline,
                                    ),
                                    _buildTipItem(
                                      "Bring your medical records",
                                      Icons.folder_outlined,
                                    ),
                                    _buildTipItem(
                                      "Have someone accompany you if possible",
                                      Icons.people_outline,
                                    ),
                                    _buildTipItem(
                                      "Note any symptoms or concerns",
                                      Icons.note_alt_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Footer
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  color: Colors.purple[800]!.withOpacity(0.8),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: const Text(
                        "Track your pregnancy journey with our app - Regular check-ups ensure a healthy pregnancy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckupItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.purple[600], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
