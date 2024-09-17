import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusion charts

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        backgroundColor: Colors.blue, // Set AppBar background color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set back arrow color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Loan Distribution by Employment Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildLoanByEmploymentStatusBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanByEmploymentStatusBarChart() {
    final data = [
      _ChartData('Employed', 50),
      _ChartData('Unemployed', 30),
      _ChartData('Self-Employed', 20),
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.value,
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.category, this.value);
  final String category;
  final double value;
}
