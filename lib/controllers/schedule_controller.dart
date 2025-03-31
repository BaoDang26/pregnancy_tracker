import 'dart:convert';

import 'package:get/get.dart';
import 'package:pregnancy_tracker/repositories/schedule_repository.dart';
import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../routes/app_routes.dart';
import '../controllers/account_profile_controller.dart';
import '../util/app_export.dart';

class ScheduleController extends GetxController {
  var isLoading = true.obs;
  var scheduleList = <ScheduleModel>[].obs;
  var scheduleModel = ScheduleModel().obs;
  late int pregnancyId;

  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  var allSchedules = <ScheduleModel>[].obs;

  RxBool isRegularUser = false.obs;

  @override
  void onInit() async {
    pregnancyId = int.parse(Get.parameters['pregnancyId']!);

    await getScheduleList();
    searchController.addListener(_onSearchChanged);
    super.onInit();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);

    super.onClose();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    _filterSchedules();
  }

  void _filterSchedules() {
    if (searchQuery.value.isEmpty) {
      scheduleList.value = allSchedules;
    } else {
      scheduleList.value = allSchedules
          .where((schedule) =>
              schedule.title != null &&
              schedule.title!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  Future<void> getScheduleList() async {
    isLoading.value = true;
    var response = await ScheduleRepository.getScheduleList(pregnancyId);

    // Log thông tin response để debug

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);

      // Chuyển đổi từ JSON sang model
      List<ScheduleModel> allSchedulesFromApi =
          scheduleModelFromJson(jsonResult);

      // Lọc ra chỉ những schedule có status là ACTIVE
      allSchedules.value = allSchedulesFromApi
          .where((schedule) => schedule.status?.toUpperCase() == 'ACTIVE')
          .toList();

      //sort schedule by date
      allSchedules.sort((a, b) => a.eventDate!.compareTo(b.eventDate!));
      // Khởi tạo danh sách hiển thị
      scheduleList.value = allSchedules;

      //áp dụng search
      searchController.addListener(_onSearchChanged);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToCreateSchedule() async {
    final result = await Get.toNamed(AppRoutes.createSchedule, parameters: {
      'pregnancyId': pregnancyId.toString(),
    });
    if (result == true) {
      await getScheduleList();
    }
  }

  void goToUpdateSchedule(int index) async {
    final result = await Get.toNamed(AppRoutes.updateSchedule, parameters: {
      'scheduleId': scheduleList[index].id.toString(),
      'pregnancyId': pregnancyId.toString()
    });
    if (result == true) {
      await getScheduleList();
    }
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
  Future<void> deleteSchedule(int scheduleId) async {
    isLoading.value = true;
    var response = await ScheduleRepository.deleteSchedule(scheduleId);

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Schedule deleted successfully");
      Get.offAllNamed(AppRoutes.schedule, parameters: {
        'pregnancyId': pregnancyId.toString(),
      }); // Cập nhật lại danh sách
    } else {
      Get.snackbar(
          "Error ${response.statusCode}", jsonDecode(response.body)['message']);
      print("Error ${response.statusCode}");
      print("Error body ${response.body}");
    }
    isLoading.value = false;
    update();
  }

  void getBack() {
    Get.back();
  }

  bool checkRegularUser() {
    if (PrefUtils.getUserRole() == 'ROLE_USER') {
      return true;
    }
    return false;
  }
}
