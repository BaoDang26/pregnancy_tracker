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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 3000,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF0F8FF), // Alice Blue
                Color(0xFFF5F5F5), // White Smoke
                Color(0xFFF0FFFF), // Azure
                Color(0xFFF8F8FF), // Ghost White
                Color(0xFFF0F8FF), // Alice Blue again
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildIntroductionSection(),
                    const SizedBox(height: 32),
                    _buildChartsSection(),
                    const SizedBox(height: 32),
                    _buildReferenceSection(),
                    const SizedBox(height: 32),
                    _buildMeasurementListSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.subdirectory_arrow_left,
                    color: Colors.white),
                label: const Text('Pregnancy Profile Details',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.pregnancyprofiledetails,
                      parameters: {
                        'pregnancyId': controller.pregnancyId.toString(),
                      });
                },
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF64B5F6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.monitor_weight_outlined,
                  size: 32,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fetal Growth Measurement',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Track and monitor your baby\'s development',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add New Measurement',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Get.toNamed(AppRoutes.createfetalgrowthmeasurement,
                      parameters: {
                        'pregnancyId': controller.pregnancyId.toString(),
                      });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF1976D2), size: 28),
              SizedBox(width: 12),
              Text(
                'About Fetal Growth Measurement',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Monitoring your baby\'s growth is essential for ensuring healthy development throughout your pregnancy. '
            'Regular measurements help detect potential issues early and provide reassurance about your baby\'s progress.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoCard(
                Icons.show_chart,
                'Growth Patterns',
                'Track changes in your baby\'s height and weight across weeks',
                Colors.blue[700]!,
              ),
              const SizedBox(width: 16),
              _buildInfoCard(
                Icons.compare_arrows,
                'Compare with Standards',
                'See how your baby\'s measurements compare with standard growth curves',
                Colors.green[700]!,
              ),
              const SizedBox(width: 16),
              _buildInfoCard(
                Icons.warning_amber,
                'Early Detection',
                'Identify potential growth issues earlier through consistent monitoring',
                Colors.amber[700]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      IconData icon, String title, String description, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bar_chart, color: Color(0xFF1976D2), size: 28),
            SizedBox(width: 12),
            Text(
              'Growth Charts',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildWeightChart(),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildHeightChart(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.monitor_weight, color: Colors.green),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Measured in grams (g)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 800,
            width: double.infinity,
            child: Obx(() {
              if (controller.weightData.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart_outlined,
                          size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No weight data available.',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Add measurements to see your baby\'s growth curve.',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                );
              }
              return SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: const EdgeInsets.all(32),
                plotAreaBackgroundColor: Colors.transparent,
                title: ChartTitle(
                  text: 'Weight Over Gestational Weeks',
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: NumericAxis(
                  title: AxisTitle(text: 'Gestational Weeks'),
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  minimum: 0,
                  maximum: 45,
                  interval: 5,
                  majorGridLines:
                      const MajorGridLines(width: 0.5, color: Colors.grey),
                  plotOffset: 20,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Weight (g)'),
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  majorGridLines:
                      const MajorGridLines(width: 0.5, color: Colors.grey),
                  plotOffset: 20,
                ),
                series: <CartesianSeries>[
                  LineSeries<WeightData, num>(
                    dataSource: getReferenceWeightData(),
                    xValueMapper: (WeightData data, _) => data.week,
                    yValueMapper: (WeightData data, _) => data.weight,
                    name: 'Reference Weight',
                    color: const Color(0xFF64B5F6),
                    width: 2,
                    dashArray: const <double>[5, 3],
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      height: 5,
                      width: 5,
                      borderWidth: 2,
                      borderColor: Color(0xFF1976D2),
                    ),
                  ),
                  LineSeries<WeightData, num>(
                    dataSource: controller.weightData,
                    xValueMapper: (WeightData data, _) => data.week,
                    yValueMapper: (WeightData data, _) => data.weight,
                    name: 'Your Baby\'s Weight',
                    color: const Color(0xFF43A047),
                    width: 3,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      height: 5,
                      width: 5,
                      borderWidth: 2,
                      borderColor: Color(0xFF2E7D32),
                    ),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text(
            '• Weight is a key indicator of your baby\'s overall development',
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          const Text(
            '• The reference curve shows the expected weight range',
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.height, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Height Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    'Measured in centimeters (cm)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 700,
            width: double.infinity,
            child: Obx(() {
              if (controller.heightData.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart_outlined,
                          size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No height data available.',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Add measurements to see your baby\'s growth curve.',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                );
              }
              return SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: const EdgeInsets.all(32),
                plotAreaBackgroundColor: Colors.transparent,
                title: ChartTitle(
                  text: 'Height Over Gestational Weeks',
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: NumericAxis(
                  title: AxisTitle(text: 'Gestational Weeks'),
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  minimum: 0,
                  maximum: 45,
                  interval: 5,
                  majorGridLines:
                      const MajorGridLines(width: 0.5, color: Colors.grey),
                  plotOffset: 20,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Height (cm)'),
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  majorGridLines:
                      const MajorGridLines(width: 0.5, color: Colors.grey),
                  plotOffset: 20,
                ),
                series: <CartesianSeries>[
                  LineSeries<HeightData, num>(
                    dataSource: getReferenceHeightData(),
                    xValueMapper: (HeightData data, _) => data.week,
                    yValueMapper: (HeightData data, _) => data.height,
                    name: 'Reference Height',
                    color: const Color(0xFF7986CB),
                    dashArray: const <double>[5, 3],
                    width: 2,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      height: 5,
                      width: 5,
                      borderWidth: 2,
                      borderColor: Color(0xFF3F51B5),
                    ),
                  ),
                  LineSeries<HeightData, num>(
                    dataSource: controller.heightData,
                    xValueMapper: (HeightData data, _) => data.week,
                    yValueMapper: (HeightData data, _) => data.height,
                    name: 'Your Baby\'s Height',
                    color: const Color(0xFF9C27B0),
                    width: 3,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      height: 5,
                      width: 5,
                      borderWidth: 2,
                      borderColor: Color(0xFF7B1FA2),
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: const TextStyle(fontSize: 10),
                      builder: (dynamic data, dynamic point, dynamic series,
                          int pointIndex, int seriesIndex) {
                        // Tìm chiều cao tham chiếu cho tuần này
                        double referenceHeight = getReferenceHeightData()
                            .firstWhere(
                              (element) => element.week == data.week,
                              orElse: () => HeightData(data.week, 0),
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
                              borderRadius: BorderRadius.circular(4),
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
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.red),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Height Alert: Values outside 3cm range from the reference may require medical attention',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.library_books, color: Color(0xFF1976D2), size: 24),
              SizedBox(width: 12),
              Text(
                'References & Resources',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.medical_information, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'WHO Fetal Growth Standards',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The dotted blue and purple lines represent standard growth curves based on World Health Organization data.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => launchUrl(Uri.parse(
                            'https://www.vinmec.com/vie/bai-viet/bang-can-nang-va-chieu-dai-thai-nhi-theo-tieu-chuan-cua-who-vi')),
                        child: const Row(
                          children: [
                            Icon(Icons.link, size: 14, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              'WHO Fetal Growth Standards (Vinmec)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.help_outline, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'How to Use This Chart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Add your measurements regularly after each doctor\'s visit\n'
                        '• Compare your baby\'s growth with the reference lines\n'
                        '• Consult with your doctor if measurements deviate significantly',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => Get.toNamed(
                            AppRoutes.createfetalgrowthmeasurement,
                            arguments: controller.pregnancyId),
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle_outline,
                                size: 14, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              'Add a new measurement now',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
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
        ],
      ),
    );
  }

  Widget _buildMeasurementListSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.format_list_bulleted,
                        color: Color(0xFF1976D2), size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Measurement History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.createfetalgrowthmeasurement,
                        parameters: {
                          'pregnancyId': controller.pregnancyId.toString(),
                        });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (controller.fetalGrowthMeasurementModel.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notes, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No measurements recorded yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first measurement to begin tracking',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(AppRoutes.createfetalgrowthmeasurement,
                              arguments: controller.pregnancyId);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Measurement'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.fetalGrowthMeasurementModel.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final measurement =
                    controller.fetalGrowthMeasurementModel[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            '${measurement.weekNumber}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Week ${measurement.weekNumber} Measurement',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(measurement.measurementDate!),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                _buildMeasurementDetail(
                                  Icons.monitor_weight,
                                  'Weight (g)',
                                  '${measurement.weight}',
                                  Colors.green,
                                ),
                                _buildMeasurementDetail(
                                  Icons.height,
                                  'Height (cm)',
                                  '${measurement.height}',
                                  Colors.purple,
                                ),
                                _buildMeasurementDetail(
                                  Icons.roundabout_left,
                                  'Head circumference (cm)',
                                  '${measurement.headCircumference}',
                                  Colors.blue,
                                ),
                                _buildMeasurementDetail(
                                  Icons.circle_outlined,
                                  'Belly circumference (cm)',
                                  '${measurement.bellyCircumference}',
                                  Colors.orange,
                                ),
                                _buildMeasurementDetail(
                                  Icons.favorite,
                                  'Heart Rate (bpm)',
                                  '${measurement.heartRate}',
                                  Colors.red,
                                ),
                                _buildMeasurementDetail(
                                  Icons.directions_run,
                                  'Movement count (times/hour)',
                                  '${measurement.movementCount}/hour',
                                  Colors.purple,
                                ),
                                _buildMeasurementDetail(
                                  Icons.note,
                                  'Notes',
                                  '${measurement.notes}',
                                  Colors.purple,
                                ),
                              ],
                            ),
                            if (measurement.notes?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.note,
                                        color: Colors.grey, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        measurement.notes!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.blue),
                            onPressed: () =>
                                controller.navigateToUpdateMeasurement(index),
                            tooltip: 'Edit',
                            splashRadius: 24,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                      'Are you sure you want to delete this measurement?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        controller
                                            .deleteMeasurement(measurement.id!);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            tooltip: 'Delete',
                            splashRadius: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMeasurementDetail(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

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
}
