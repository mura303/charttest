import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:async';
import 'dart:math';

Random random = Random();
Timer? timer;
// Redraw the series with updating or creating new points by using this controller.
ChartSeriesController? _chartSeriesController;

//Initialize the data source
List<_ChartData> chartData = <_ChartData>[
  _ChartData(0, 42),
  _ChartData(1, 47),
  _ChartData(2, 33),
  _ChartData(3, 49),
  _ChartData(4, 54),
  _ChartData(5, 41),
  _ChartData(6, 58),
  _ChartData(7, 51),
  _ChartData(8, 98),
  _ChartData(9, 41),
  _ChartData(10, 53),
  _ChartData(11, 72),
  _ChartData(12, 86),
  _ChartData(13, 52),
  _ChartData(14, 94),
  _ChartData(15, 92),
  _ChartData(16, 86),
  _ChartData(17, 72),
  _ChartData(18, 94),
];
// Count of type integer which binds as x value for the series
int count = 19;

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  void _updateDataSource(Timer timer) {
    chartData.add(_ChartData(count, 10 + random.nextInt(100 - 10)));
    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0]);
    }
    count = count + 1;
  }

  @override
  Widget build(BuildContext context) {
    // Here the _updateDataSource method is called for every second.
    timer =
        Timer.periodic(const Duration(milliseconds: 250), _updateDataSource);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Column(children: [
          SfCartesianChart(
            series: <LineSeries<_ChartData, int>>[
              LineSeries<_ChartData, int>(
                onRendererCreated: (ChartSeriesController controller) {
                  // Assigning the controller to the _chartSeriesController.
                  _chartSeriesController = controller;
                },
                // Binding the chartData to the dataSource of the line series.
                dataSource: chartData,
                xValueMapper: (_ChartData sales, _) => sales.country,
                yValueMapper: (_ChartData sales, _) => sales.sales,
              )
            ],
          ),
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
            ),
          )
        ]));
  }

  @override
  void dispose() {
    super.dispose();
    // Cancelling the timer.
    timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.country, this.sales);
  final int country;
  final int sales;
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
