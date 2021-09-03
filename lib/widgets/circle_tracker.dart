import 'package:caphe_v2/widgets/timeline.dart';
import 'package:flutter/material.dart';
import 'package:caphe_v2/widgets/legend.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

class CircleTracker extends StatefulWidget {
  CircleTracker(
      {Key? key,
      required this.daysLeft,
      required this.species,
      required this.finishedStages,
      required this.dates,
      required this.harvest,
      required this.tips})
      : super(key: key);
  int daysLeft;
  String species;
  Set<String> finishedStages;
  DateTime harvest;
  Map<String, DateTime> dates;
  List<String> tips;

  @override
  _CircleTrackerState createState() => _CircleTrackerState();
}

class _CircleTrackerState extends State<CircleTracker> {
  var dateFormatter = new DateFormat('MMM dd, yyyy');

  static const Map<String, String> speciesdata = {
    'robusta': 'Robusta',
    'arabica': 'Arabica',
    'liberica': 'Liberica',
    'excelsa': 'Excelsa'
  };

  @override
  Widget build(BuildContext context) {
    print(widget.species);
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
              child: Text(
            "Track your harvest dates and phenological stage using the BBCH scale.",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          )),
        ),
        Container(
          width: 300,
          height: 300,
          child: Gauge(
              label: '1',
              harvestWeek: widget.daysLeft,
              species: widget.species),
        ),
        Container(
          child: Center(
              child: Text(
            speciesdata[widget.species].toString(),
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
              child: Text(
            'Estimated Harvest week of',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            dateFormatter
                    .format(widget.harvest.subtract(const Duration(days: 3)))
                    .toString() +
                ' to ' +
                dateFormatter
                    .format(widget.harvest.add(const Duration(days: 3)))
                    .toString(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          )),
        ),
        Legend(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            "Phenological Stages",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: BerryTimeline(
                  title: '1',
                  finishedStages: widget.finishedStages,
                  remainingStages: widget.dates,
                  harvest: widget.harvest,
                  species: widget.species,
                  tips: widget.tips)),
        ),
        Padding(padding: const EdgeInsets.all(20)),
      ],
    );
  }
}



class Gauge extends StatelessWidget {
  Gauge(
      {Key? key,
      required this.label,
      required this.harvestWeek,
      required this.species})
      : super(key: key);
  final label;
  late var harvestWeek;
  final String species;
  final double widthVar = 20;

  ///average number of weeks for each stage and each variety
  final values = {
    'robusta': [15, 18, 48, 62],
    'arabica': [16, 20, 46, 57],
    'excelsa': [19, 22, 61, 69],
    'liberica': [20, 25, 58, 69]
  };

  @override
  Widget build(BuildContext context) {
    var tempHW = harvestWeek;
    tempHW = (tempHW.toDouble() / 7);
    final computedHarvestWeek = (values[species]![3].toDouble() - tempHW);
    final textCompHarv = tempHW.toStringAsFixed(0);
    return Container(
        child: SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          minimum: 1,
          maximum: values[species]![3].toDouble(),
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: values[species]![0].toDouble(),
                color: Colors.green[400],
                startWidth: widthVar,
                endWidth: widthVar),
            GaugeRange(
                startValue: values[species]![0].toDouble(),
                endValue: values[species]![1].toDouble(),
                color: Colors.blue[400],
                startWidth: widthVar,
                endWidth: widthVar),
            GaugeRange(
                startValue: values[species]![1].toDouble(),
                endValue: values[species]![2].toDouble(),
                color: Colors.purple[400],
                startWidth: widthVar,
                endWidth: widthVar),
            GaugeRange(
                startValue: values[species]![2].toDouble(),
                endValue: values[species]![3].toDouble(),
                color: Colors.red[400],
                startWidth: widthVar,
                endWidth: widthVar)
          ],
          pointers: <GaugePointer>[
            NeedlePointer(value: computedHarvestWeek)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text('$textCompHarv weeks left',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
    ]));
  }
}
