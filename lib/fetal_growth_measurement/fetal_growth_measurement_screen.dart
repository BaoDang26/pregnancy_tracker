import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pregnancy_tracker/models/fetal_growth_measurement_model.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../controllers/fetal_growth_measurement_controller.dart';

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
          decoration: BoxDecoration(
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
                Text(
                  'Fetal Growth Statistics',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.weightData.isEmpty) {
                            return Center(
                                child: Text('No weight data available.'));
                          }
                          return SfCartesianChart(
                            title: ChartTitle(
                                text: 'Weight Over Gestational Weeks'),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Gestational Weeks'),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Height (cm)'),
                            ),
                            series: <CartesianSeries>[
                              LineSeries<WeightData, String>(
                                dataSource: controller.weightData,
                                xValueMapper: (WeightData data, _) =>
                                    data.week.toString(),
                                yValueMapper: (WeightData data, _) =>
                                    data.weight,
                                name: 'Weight (User Data)',
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                              ),
                              LineSeries<WeightData, String>(
                                dataSource: getReferenceWeightData(),
                                xValueMapper: (WeightData data, _) =>
                                    data.week.toString(),
                                yValueMapper: (WeightData data, _) =>
                                    data.weight,
                                name: 'Weight (Reference Data)',
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                color: Colors.purple,
                                dashArray: <double>[5, 5],
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: 16),
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.heightData.isEmpty) {
                            return Center(
                                child: Text('No height data available.'));
                          }
                          return SfCartesianChart(
                            title: ChartTitle(
                                text: 'Height Over Gestational Weeks'),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Gestational Weeks'),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Height (cm)'),
                            ),
                            series: <CartesianSeries>[
                              LineSeries<HeightData, String>(
                                dataSource: controller.heightData,
                                xValueMapper: (HeightData data, _) =>
                                    data.week.toString(),
                                yValueMapper: (HeightData data, _) =>
                                    data.height,
                                name: 'Height (User Data)',
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  builder: (dynamic data,
                                      dynamic point,
                                      dynamic series,
                                      int pointIndex,
                                      int seriesIndex) {
                                    // Find reference height for this week
                                    double referenceHeight =
                                        getReferenceHeightData()
                                            .firstWhere(
                                              (element) =>
                                                  element.week == data.week!,
                                              orElse: () =>
                                                  HeightData(data.week!, 0),
                                            )
                                            .height;

                                    // Check if height deviation is more than 3cm
                                    double deviation =
                                        (data.height! - referenceHeight).abs();
                                    if (deviation > 3) {
                                      return Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${data.height!.toStringAsFixed(1)}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              '⚠️ ${deviation.toStringAsFixed(1)}cm',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Text(
                                        data.height!.toStringAsFixed(1));
                                  },
                                ),
                              ),
                              LineSeries<HeightData, String>(
                                dataSource: getReferenceHeightData(),
                                xValueMapper: (HeightData data, _) =>
                                    data.week.toString(),
                                yValueMapper: (HeightData data, _) =>
                                    data.height,
                                name: 'Height (Reference Data)',
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                color: Colors.purple,
                                dashArray: <double>[5, 5],
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                if (controller.isLoading.value) {
                                  return CircularProgressIndicator();
                                }
                                if (controller
                                    .fetalGrowthMeasurementModel.isEmpty) {
                                  return Text('No data available');
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Measurement Date: ${DateFormat('yyyy-MM-dd').format(controller.fetalGrowthMeasurementModel.last.measurementDate!)}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Head Circumference: ${controller.fetalGrowthMeasurementModel.last.headCircumference} cm',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Belly Circumference: ${controller.fetalGrowthMeasurementModel.last.bellyCircumference} cm',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Heart Rate: ${controller.fetalGrowthMeasurementModel.last.heartRate} bpm',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Notes: ${controller.fetalGrowthMeasurementModel.last.notes}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: CustomElevatedButton(
                        // width: 100,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Update Information',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Container(
                                  width: 600,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: controller
                                        .fetalGrowthMeasurementFormKey,
                                    child: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller: controller
                                                  .measurementDateController,
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime.now(),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                          primary: Colors.green,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors.black,
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.green,
                                                          ),
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
                                                  controller
                                                      .measurementDateController
                                                      .text = formattedDate;
                                                }
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select measurement date';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Measurement Date',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                suffixIcon: Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller: controller
                                                  .weekNumberController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter week number';
                                                }
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return 'Please enter a valid number';
                                                }
                                                final week = int.parse(value);
                                                if (week < 1 || week > 42) {
                                                  return 'Week must be between 1 and 42';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Week Number',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  controller.weightController,
                                              validator: (value) {
                                                return controller
                                                    .validateWeight(value!);
                                              },
                                              onSaved: (value) {
                                                controller.weight = value!;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Weight (g)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  controller.heightController,
                                              validator: (value) {
                                                return controller
                                                    .validateHeight(value!);
                                              },
                                              onSaved: (value) {
                                                controller.height = value!;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Height (cm)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller: controller
                                                  .headCircumferenceController,
                                              validator: (value) {
                                                return controller
                                                    .validateHeadCircumference(
                                                        value!);
                                              },
                                              onSaved: (value) {
                                                controller.headCircumference =
                                                    value!;
                                              },
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Head Circumference (cm)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller: controller
                                                  .bellyCircumferenceController,
                                              validator: (value) {
                                                return controller
                                                    .validateBellyCircumference(
                                                        value!);
                                              },
                                              onSaved: (value) {
                                                controller.bellyCircumference =
                                                    value!;
                                              },
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Belly Circumference (cm)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller: controller
                                                  .heartRateController,
                                              validator: (value) {
                                                return controller
                                                    .validateHeartRate(value!);
                                              },
                                              onSaved: (value) {
                                                controller.heartRate = value!;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Heart Rate (bpm)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[200]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  controller.notesController,
                                              // validator: (value) {
                                              //   return controller
                                              //       .validateNotes(value!);
                                              // },
                                              onSaved: (value) {
                                                controller.notes = value!;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Notes',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.green[500]!),
                                                ),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                              maxLines: 5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Update'),
                                    onPressed: () async {
                                      await controller
                                          .addFetalGrowthMeasurement();
                                      Navigator.of(context).pop();
                                      // await controller
                                      //     .fetchFetalGrowthMeasurementData();

                                      // TODO: Update the data using your controller
                                      // controller.updateMeasurements(...)

                                      // Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        text: 'Update',
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
      WeightData(1, 20),
      WeightData(2, 30),
      WeightData(3, 40),
      WeightData(4, 60),
      WeightData(5, 80),
      WeightData(6, 130),
      WeightData(7, 180),
      WeightData(8, 240),
      WeightData(9, 350),
      WeightData(9, 490),
      // Thêm dữ liệu tham khảo khác nếu cần
    ];
  }

  List<HeightData> getReferenceHeightData() {
    return [
      HeightData(1, 6),
      HeightData(2, 7),
      HeightData(3, 9),
      HeightData(4, 12),
      HeightData(5, 14),
      HeightData(6, 18),
      HeightData(7, 22),
      HeightData(8, 25),
      HeightData(9, 30),
      HeightData(10, 35),
      HeightData(11, 35),
      HeightData(12, 40),
      HeightData(13, 45),
      HeightData(14, 50),
      HeightData(15, 55),
      HeightData(16, 60),
      HeightData(40, 65),
      // Thêm dữ liệu tham khảo khác nếu cần
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
