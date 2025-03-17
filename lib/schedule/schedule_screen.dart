import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/schedule_controller.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 200, 240, 250),
              Color.fromARGB(255, 190, 250, 240),
              Color.fromARGB(255, 180, 230, 230),
              const Color.fromARGB(255, 170, 240, 210),
              Color.fromARGB(255, 160, 220, 200),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Appointments',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: CustomElevatedButton(
                      onPressed: () {
                        controller.goToCreateSchedule();
                      },
                      text: 'Add New Appointment',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subheader with info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Keep track of your appointments with doctors and check-ups during your pregnancy.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main content - Schedule list
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.scheduleList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No appointments yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap "Add New Appointment" to create your first appointment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.scheduleList.length,
                    itemBuilder: (context, index) {
                      final schedule = controller.scheduleList[index];

                      // Format date
                      String formattedDate = "N/A";
                      if (schedule.eventDate != null) {
                        formattedDate = DateFormat('EEE, MMM d, yyyy')
                            .format(schedule.eventDate!);
                      }

                      // Kiểm tra ngày đã qua hay chưa để thay đổi màu sắc
                      final isPastDate = schedule.eventDate != null &&
                          schedule.eventDate!.isBefore(
                              DateTime.now().subtract(const Duration(days: 1)));
                      final cardColor = isPastDate ? Colors.grey : Colors.blue;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            // controller.goToScheduleDetail(index);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cardColor.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Card header with status & actions
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: cardColor.withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            isPastDate
                                                ? Icons.event_busy
                                                : Icons.event_available,
                                            color: cardColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            isPastDate ? 'PAST' : 'UPCOMING',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: cardColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Edit button
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () {
                                              controller
                                                  .goToUpdateSchedule(index);
                                            },
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          const SizedBox(width: 16),
                                          // Delete button
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              Get.dialog(
                                                AlertDialog(
                                                  title: const Text(
                                                      'Delete Appointment'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this appointment?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                        // controller
                                                        //     .deleteSchedule(
                                                        //         schedule.id!);
                                                      },
                                                      child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Card content
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule.title ??
                                            'Untitled Appointment',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 18,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 8),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          // Hiển thị ngày còn lại nếu là ngày trong tương lai
                                          if (!isPastDate &&
                                              schedule.eventDate != null) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              '(${_getDaysRemaining(schedule.eventDate!)})',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (schedule.description != null &&
                                          schedule.description!.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.description,
                                                size: 18,
                                                color: Colors.grey[600]),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                schedule.description!,
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tính số ngày còn lại
  String _getDaysRemaining(DateTime eventDate) {
    final now = DateTime.now();
    final difference = eventDate.difference(now).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Tomorrow";
    } else {
      return "$difference days left";
    }
  }
}
