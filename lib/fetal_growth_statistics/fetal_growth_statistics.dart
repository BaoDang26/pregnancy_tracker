import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/widgets/custom_elevated_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FetalGrowthStatistics extends StatefulWidget {
  @override
  _FetalGrowthStatisticsState createState() => _FetalGrowthStatisticsState();
}

class _FetalGrowthStatisticsState extends State<FetalGrowthStatistics> {
  @override
  Widget build(BuildContext context) {
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
                        child: SfCartesianChart(
                          title:
                              ChartTitle(text: 'Weight Over Gestational Weeks'),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          primaryXAxis: CategoryAxis(
                            title: AxisTitle(text: 'Gestational Weeks'),
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Weight (grams)'),
                          ),
                          series: <CartesianSeries>[
                            LineSeries<WeightData, String>(
                              dataSource: getWeightData(),
                              xValueMapper: (WeightData data, _) => data.week,
                              yValueMapper: (WeightData data, _) => data.weight,
                              name: 'Weight (User Data)',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                            LineSeries<WeightData, String>(
                              dataSource: getReferenceWeightData(),
                              xValueMapper: (WeightData data, _) => data.week,
                              yValueMapper: (WeightData data, _) => data.weight,
                              name: 'Weight (Reference Data)',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                              color: Colors.red,
                              dashArray: <double>[5, 5],
                            ),
                          ],
                        ),
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
                        child: SfCartesianChart(
                          title:
                              ChartTitle(text: 'Height Over Gestational Weeks'),
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
                              dataSource: getHeightData(),
                              xValueMapper: (HeightData data, _) => data.week,
                              yValueMapper: (HeightData data, _) => data.height,
                              name: 'Height (User Data)',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                            LineSeries<HeightData, String>(
                              dataSource: getReferenceHeightData(),
                              xValueMapper: (HeightData data, _) => data.week,
                              yValueMapper: (HeightData data, _) => data.height,
                              name: 'Height (Reference Data)',
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                              color: Colors.blue,
                              dashArray: <double>[5, 5],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Measurement Date: ${measurementDate != null ? measurementDate.toLocal().toString().split(' ')[0] : 'N/A'}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Head Circumference: $headCircumference cm',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Belly Circumference: $bellyCircumference cm',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Heart Rate: $heartRate bpm',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Notes: $notes',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    CustomElevatedButton(
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Weight (g)',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[500]!),
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Height (cm)',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[500]!),
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                'Head Circumference (cm)',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[500]!),
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                'Belly Circumference (cm)',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[500]!),
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Heart Rate (bpm)',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[500]!),
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Notes',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: Colors.green[500]!),
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
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Update'),
                                  onPressed: () {
                                    // Thêm mã để xử lý cập nhật thông tin ở đây
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      text: 'Update',
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

  List<WeightData> getWeightData() {
    return [
      WeightData('Week 1', 14),
      WeightData('Week 2', 20),
      WeightData('Week 3', 30),
      WeightData('Week 4', 50),
      WeightData('Week 5', 70),
      WeightData('Week 6', 100),
      WeightData('Week 7', 150),
      WeightData('Week 8', 200),
      WeightData('Week 9', 300),
      WeightData('Week 10', 400),
      // Add more data as needed
    ];
  }

  List<HeightData> getHeightData() {
    return [
      HeightData('Week 1', 5),
      HeightData('Week 2', 6),
      HeightData('Week 3', 8),
      HeightData('Week 4', 10),
      HeightData('Week 5', 12),
      HeightData('Week 6', 15),
      HeightData('Week 7', 18),
      HeightData('Week 8', 20),
      HeightData('Week 9', 25),
      HeightData('Week 10', 30),
      // Add more data as needed
    ];
  }

  List<WeightData> getReferenceWeightData() {
    return [
      WeightData('Week 1', 20),
      WeightData('Week 2', 30),
      WeightData('Week 3', 40),
      WeightData('Week 4', 60),
      WeightData('Week 5', 80),
      WeightData('Week 6', 130),
      WeightData('Week 7', 180),
      WeightData('Week 8', 240),
      WeightData('Week 9', 350),
      WeightData('Week 10', 490),
      // Thêm dữ liệu tham khảo khác nếu cần
    ];
  }

  List<HeightData> getReferenceHeightData() {
    return [
      HeightData('Week 1', 6),
      HeightData('Week 2', 7),
      HeightData('Week 3', 9),
      HeightData('Week 4', 12),
      HeightData('Week 5', 14),
      HeightData('Week 6', 18),
      HeightData('Week 7', 22),
      HeightData('Week 8', 25),
      HeightData('Week 9', 30),
      HeightData('Week 10', 35),
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
  final String week;
  final double weight;
}

class HeightData {
  HeightData(this.week, this.height);
  final String week;
  final double height;
}
