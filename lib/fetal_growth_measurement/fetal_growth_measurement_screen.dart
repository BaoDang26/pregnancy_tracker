import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pregnancy_tracker/models/fetal_growth_measurement_model.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/fetal_growth_measurement_controller.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';

class FetalGrowthMeasurementScreen
    extends GetView<FetalGrowthMeasurementController> {
  FetalGrowthMeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra dữ liệu
    print('Height Data: ${controller.heightData}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 200, 240, 250),
                Color.fromARGB(255, 190, 250, 240),
                Color.fromARGB(255, 180, 230, 230),
                Color.fromARGB(255, 170, 240, 210),
                Color.fromARGB(255, 160, 220, 200),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fetal Growth Measurement',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.green[700]),
                          onPressed: () {
                            // Call the method to refresh the fetal growth measurements
                            controller.getFetalGrowthMeasurement(
                                controller.pregnancyId);
                            controller
                                .getHeightMeasurements(controller.pregnancyId);
                            controller
                                .getWeightMeasurements(controller.pregnancyId);
                          },
                          tooltip: 'Refresh',
                        ),
                        SizedBox(
                          width: 300, // Giới hạn chiều rộng của nút
                          child: CustomElevatedButton(
                            onPressed: () {
                              Get.toNamed(
                                  AppRoutes.createfetalgrowthmeasurement,
                                  arguments: controller.pregnancyId);
                            },
                            text: 'Add Measurement',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 700,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.weightData.isEmpty) {
                            return const Center(
                                child: Text('No weight data available.'));
                          }
                          return SfCartesianChart(
                            title: const ChartTitle(
                                text: 'Weight Over Gestational Weeks'),
                            legend: const Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            primaryXAxis: const NumericAxis(
                              title: AxisTitle(text: 'Gestational Weeks'),
                              minimum: 0,
                              maximum: 45,
                              interval: 5,
                            ),
                            primaryYAxis: const NumericAxis(
                              title: AxisTitle(text: 'Weight (g)'),
                            ),
                            series: <CartesianSeries>[
                              LineSeries<WeightData, num>(
                                dataSource: getReferenceWeightData(),
                                xValueMapper: (WeightData data, _) => data.week,
                                yValueMapper: (WeightData data, _) =>
                                    data.weight,
                                name: 'Reference Weight',
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              LineSeries<WeightData, num>(
                                dataSource: controller.weightData,
                                xValueMapper: (WeightData data, _) => data.week,
                                yValueMapper: (WeightData data, _) =>
                                    data.weight,
                                name: 'Your Baby\'s Weight',
                                color: Colors.green,
                                width: 3,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 8,
                                  width: 8,
                                ),
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 700,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.heightData.isEmpty) {
                            return const Center(
                                child: Text('No height data available.'));
                          }
                          return SfCartesianChart(
                            title: const ChartTitle(
                                text: 'Height Over Gestational Weeks'),
                            legend: const Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            primaryXAxis: const NumericAxis(
                              title: AxisTitle(text: 'Gestational Weeks'),
                              minimum: 0,
                              maximum: 45,
                              interval: 5,
                            ),
                            primaryYAxis: const NumericAxis(
                              title: AxisTitle(text: 'Height (cm)'),
                            ),
                            series: <CartesianSeries>[
                              LineSeries<HeightData, num>(
                                dataSource: getReferenceHeightData(),
                                xValueMapper: (HeightData data, _) => data.week,
                                yValueMapper: (HeightData data, _) =>
                                    data.height,
                                name: 'Reference Height',
                                color: Colors.grey[300],
                                width: 2,
                              ),
                              LineSeries<HeightData, num>(
                                dataSource: controller.heightData,
                                xValueMapper: (HeightData data, _) => data.week,
                                yValueMapper: (HeightData data, _) =>
                                    data.height,
                                dataLabelMapper: (HeightData data, _) =>
                                    'Week: ${data.week}\nHeight: ${data.height.toStringAsFixed(1)} cm',
                                name: 'Your Baby\'s Height',
                                color: Colors.purple,
                                width: 3,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  height: 8,
                                  width: 8,
                                ),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                  builder: (dynamic data,
                                      dynamic point,
                                      dynamic series,
                                      int pointIndex,
                                      int seriesIndex) {
                                    // Tìm chiều cao tham chiếu cho tuần này
                                    double referenceHeight =
                                        getReferenceHeightData()
                                            .firstWhere(
                                              (element) =>
                                                  element.week == data.week,
                                              orElse: () =>
                                                  HeightData(data.week, 0),
                                            )
                                            .height;

                                    // Kiểm tra độ chênh lệch
                                    double deviation =
                                        (data.height - referenceHeight).abs();
                                    if (deviation > 3) {
                                      return Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Week: ${data.week}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                            // Text(
                                            //   '${data.height.toStringAsFixed(1)}',
                                            //   style: TextStyle(
                                            //       color: Colors.white),
                                            // ),
                                            Text(
                                              '⚠️ ${deviation.toStringAsFixed(1)}cm',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Week: ${data.week}',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Text(data.height.toStringAsFixed(1)),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      'Height Alert: Values outside 3rd-97th percentile range require medical attention',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SelectableText(
                      'Note: Dotted line represents standard growth curve',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () => launchUrl(Uri.parse(
                          'https://www.vinmec.com/vie/bai-viet/bang-can-nang-va-chieu-dai-thai-nhi-theo-tieu-chuan-cua-who-vi')),
                      child: const SelectableText(
                        'Reference: WHO Fetal Growth Standards (Vinmec)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (controller
                                .fetalGrowthMeasurementModel.isEmpty) {
                              return const Center(
                                  child: Text('No data available'));
                            }
                            return Container(
                              // Thêm Container bọc ListView
                              height: 600, // Đặt chiều cao cố định
                              child: ListView.separated(
                                shrinkWrap: true, // Thêm thuộc tính này
                                physics:
                                    const AlwaysScrollableScrollPhysics(), // Thêm physics để có thể scroll
                                itemCount: controller
                                    .fetalGrowthMeasurementModel.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 20),
                                itemBuilder: (context, index) {
                                  final measurement = controller
                                      .fetalGrowthMeasurementModel[index];
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Measurement Date: ${DateFormat('yyyy-MM-dd').format(measurement.measurementDate!)}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.update,
                                                  color: Colors.red),
                                              onPressed: () {
                                                controller
                                                    .navigateToUpdateMeasurement(
                                                        index);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            const Icon(Icons.timelapse,
                                                color: Colors.green),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Pregnancy Week: ${measurement.weekNumber} ',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.monitor_weight,
                                                color: Colors.green),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Weight (g): ${measurement.weight}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.height_sharp,
                                                color: Colors.purple),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Height (cm): ${measurement.height}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.height,
                                                color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Head Circumference (cm): ${measurement.headCircumference}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.radio_button_checked,
                                                color: Colors.orange),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Belly Circumference (cm): ${measurement.bellyCircumference}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.favorite,
                                                color: Colors.red),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Heart Rate (bpm): ${measurement.heartRate}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        if (measurement.notes?.isNotEmpty ??
                                            false) ...[
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.note,
                                                  color: Colors.purple),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Notes: ${measurement.notes}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // List<WeightData> getWeightData() {
  //   return [
  //     WeightData('Week 1', 14),
  //     WeightData('Week 2', 20),
  //     WeightData('Week 3', 30),
  //     WeightData('Week 4', 50),
  //     WeightData('Week 5', 70),
  //     WeightData('Week 6', 100),
  //     WeightData('Week 7', 150),
  //     WeightData('Week 8', 200),
  //     WeightData('Week 9', 300),
  //     WeightData('Week 10', 400),

  //     // Add more data as needed
  //   ];
  // }

  List<HeightData> getHeightData() {
    return [
      HeightData(1, 5),
      HeightData(2, 6),
      // HeightData(3, 8),
      HeightData(4, 10),
      HeightData(5, 12),
      HeightData(6, 15),
      HeightData(7, 18),
      HeightData(8, 20),
      HeightData(9, 25),
      HeightData(10, 30),
      HeightData(11, 35),
      HeightData(12, 40),
      HeightData(13, 45),
      HeightData(14, 50),
      HeightData(15, 55),
      HeightData(16, 60),
      HeightData(40, 65),

      // Add more data as needed
    ];
  }

  List<WeightData> getReferenceWeightData() {
    return [
      WeightData(8, 1),
      WeightData(9, 2),
      WeightData(10, 4),
      WeightData(11, 45),
      WeightData(12, 58),
      WeightData(13, 73),
      WeightData(14, 93),
      WeightData(15, 117),
      WeightData(16, 146),
      WeightData(17, 181),
      WeightData(18, 222),
      WeightData(19, 272),
      WeightData(20, 330),
      WeightData(21, 400),
      WeightData(22, 476),
      WeightData(23, 565),
      WeightData(24, 665),
      WeightData(25, 756),
      WeightData(26, 900),
      WeightData(27, 1000),
      WeightData(28, 1100),
      WeightData(29, 1239),
      WeightData(30, 1396),
      WeightData(31, 1568),
      WeightData(32, 1755),
      WeightData(33, 2000),
      WeightData(34, 2200),
      WeightData(35, 2378),
      WeightData(36, 2600),
      WeightData(37, 2800),
      WeightData(38, 3000),
      WeightData(39, 3186),
      WeightData(40, 3338),
      WeightData(41, 3600),
      WeightData(42, 3700),
    ];
  }

  List<HeightData> getReferenceHeightData() {
    return [
      HeightData(8, 1.6),
      HeightData(9, 2.3),
      HeightData(10, 3.1),
      HeightData(11, 4.1),
      HeightData(12, 5.4),
      HeightData(13, 6.7),
      HeightData(14, 14.7),
      HeightData(15, 16.7),
      HeightData(16, 18.6),
      HeightData(17, 20.4),
      HeightData(18, 22.2),
      HeightData(19, 24.0),
      HeightData(20, 25.7),
      HeightData(21, 27.4),
      HeightData(22, 29.0),
      HeightData(23, 30.6),
      HeightData(24, 32.2),
      HeightData(25, 33.7),
      HeightData(26, 35.1),
      HeightData(27, 36.6),
      HeightData(28, 37.6),
      HeightData(29, 39.3),
      HeightData(30, 40.5),
      HeightData(31, 41.8),
      HeightData(32, 43.0),
      HeightData(33, 44.1),
      HeightData(34, 45.3),
      HeightData(35, 46.3),
      HeightData(36, 47.3),
      HeightData(37, 48.3),
      HeightData(38, 49.3),
      HeightData(39, 50.1),
      HeightData(40, 51.0),
      HeightData(41, 51.5),
      HeightData(42, 51.7),
    ];
  }

  DateTime measurementDate = DateTime.now();
  double headCircumference = 30.0;
  double bellyCircumference = 80.0;
  int heartRate = 140;
  String notes = 'All measurements are normal.';
}

class WeightData {
  WeightData(this.week, this.weight);
  final int week;
  final double weight;
}

class HeightData {
  HeightData(this.week, this.height);
  final int week;
  final double height;

  @override
  String toString() {
    return 'HeightData(week: $week, height: $height)';
  }
}
