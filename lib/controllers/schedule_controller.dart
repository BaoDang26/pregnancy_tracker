import 'dart:convert';

import 'package:get/get.dart';
import 'package:pregnancy_tracker/repositories/schedule_repository.dart';
import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../routes/app_routes.dart';
import '../controllers/account_profile_controller.dart';

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
    // Đảm bảo AccountProfileController được khởi tạo
    if (!Get.isRegistered<AccountProfileController>()) {
      await Get.put(AccountProfileController()).onInit();
    }

    pregnancyId = Get.arguments;
    await checkUserRole(); // Thêm await ở đây
    await getScheduleList();
    searchController.addListener(_onSearchChanged);
    super.onInit();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
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
      // Log kết quả JSON
      print("JSON Result: $jsonResult");

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
  Future<void> deleteSchedule(int scheduleId) async {
    isLoading.value = true;
    var response = await ScheduleRepository.deleteSchedule(scheduleId);

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Schedule deleted successfully");
      await getScheduleList(); // Cập nhật lại danh sách
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

  Future<void> checkUserRole() async {
    try {
      final accountController = Get.find<AccountProfileController>();
      // Đảm bảo dữ liệu profile đã được tải
      if (accountController.accountProfileModel.value.roleName == null) {
        await accountController.getAccountProfile();
      }
      isRegularUser.value = accountController.isRegularUser();
      print(
          "User role checked: isRegularUser = ${isRegularUser.value}"); // Debug log
      print(
          "Current role: ${accountController.accountProfileModel.value.roleName}"); // Thêm log
    } catch (e) {
      print("Error checking user role: $e");
      isRegularUser.value = true; // Default to regular user if there's an error
    }
  }
}
