import 'dart:convert';

import 'package:get/get.dart';
import 'package:pregnancy_tracker/repositories/schedule_repository.dart';

import '../models/schedule_model.dart';
import '../routes/app_routes.dart';

class ScheduleController extends GetxController {
  var isLoading = true.obs;
  var scheduleList = <ScheduleModel>[].obs;
  var scheduleModel = ScheduleModel().obs;
  late int pregnancyId;

  @override
  Future<void> onInit() async {
    await getScheduleList();
    super.onInit();
  }

  Future<void> getScheduleList() async {
    isLoading.value = true;
    var response = await ScheduleRepository.getScheduleList();

    // Log thông tin response để debug
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log kết quả JSON
      print("JSON Result: $jsonResult");

      // Chuyển đổi từ JSON sang model
      scheduleList.value = scheduleModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToCreateSchedule() {
    pregnancyId = Get.arguments;
    Get.toNamed(AppRoutes.createSchedule, arguments: pregnancyId);
    print("goToCreateSchedule: $pregnancyId");
  }

  void goToUpdateSchedule(int index) {
    var schedule = scheduleList[index];
    pregnancyId = Get.arguments;
    Get.toNamed(AppRoutes.updateSchedule,
        arguments: {'scheduleId': schedule.id, 'pregnancyId': pregnancyId});
    print("goToUpdateSchedule: $pregnancyId and $schedule.id");
  }

  // void goToScheduleDetail(int index) {
  //   Get.toNamed(AppRoutes.scheduledetails, arguments: scheduleList[index]);
  // }

  // Tùy chọn: phương thức đi đến màn hình cập nhật lịch trình
  // void goToUpdateSchedule(int index) {
  //   var schedule = scheduleList[index];
  //   Get.toNamed(
  //     AppRoutes.updateSchedule,
  //     arguments: {
  //       'scheduleId': schedule.id,
  //       // 'pregnancyId': pregnancyId,
  //     },
  //   );
  // }

  // Phương thức để xóa lịch trình
  // Future<void> deleteSchedule(int scheduleId) async {
  //   isLoading.value = true;
  //   var response = await ScheduleRepository.deleteSchedule(scheduleId);

  //   if (response.statusCode == 200) {
  //     Get.snackbar("Success", "Schedule deleted successfully");
  //     await getScheduleList(); // Cập nhật lại danh sách
  //   } else {
  //     Get.snackbar(
  //         "Error ${response.statusCode}", jsonDecode(response.body)['message']);
  //   }
  //   isLoading.value = false;
  // }

  void getBack() {
    Get.back();
  }
}
