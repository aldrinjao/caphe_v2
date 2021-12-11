import 'dart:developer';

import 'package:intl/intl.dart';


class CalculationResult {
  double? sum;
  DateTime? firstDayFound;
  int? daysLeft;
  DateTime? harvestDate;
  Map<DateTime, List<dynamic>> events = {};
  Map<String, DateTime> stages = {};

  late String todayStage ='harvest';
  late double targetBbch;
  late Set<String> finishedStages;
  List<String> tips = ['completed','completed','completed','completed'];

}


class Calculator {
  var data, weatherData;

  var dateFormatter = new DateFormat('yyyy-MM-dd');

  late int daysLeft;
  var harvestDate;
  var stages = ['inflorescence', 'flowering', 'berry development', 'berry ripening','harvest'];

  Calculator({this.weatherData});

  getResult(data) {
    Iterator weatherIterator = weatherData[data['location']]['temperatures'].iterator;
    var berriesData = weatherData[data['location']]['berries'];
    var inputDateString = dateFormatter.format(data['date'].toDate());
    var speciesData = berriesData[data['species'].toLowerCase()];
    var targetBbch = speciesData[data['bbch'].toString()];
    var stageValues = [speciesData["51"],speciesData["61"],speciesData["71"],speciesData["81"]];
    var result = new CalculationResult();
    result.targetBbch = targetBbch.toDouble();

    result.sum = 0;
    result.finishedStages = new Set<String>();
    var flags = [0,0,0,0,0,0,0];
    var lastEvent;
    var todayString = dateFormatter.format(DateTime.now());
    var isTodayFound = false;

    //currentdate is not actual current date, it's just the iterator.
    while (weatherIterator.moveNext()) {
      var current = weatherIterator.current;
      var currentDate = current['date'].toDate();
      var currentDateString = dateFormatter.format(currentDate);
      if (currentDateString == inputDateString) {
        result.firstDayFound = currentDate;
      }

      if (result.firstDayFound != null) {
        double gdd = (current['minTemp'] + current['maxTemp']) / 2.0 - 10.0;
        result.sum = (result.sum! + gdd);
        //result.events[currentDate] = ['inflorescence'];
        var remainingBbch = targetBbch - result.sum;
        var currentEvent = (remainingBbch <= stageValues[3])
            ? 'berry ripening'
            : (remainingBbch <= stageValues[2])
            ? 'berry development'
            : (remainingBbch <= stageValues[1])
            ? 'flowering'
            : 'inflorescence';
        result.events[currentDate] = [currentEvent];

        if (!isTodayFound && currentDateString == todayString) {
          isTodayFound = true;
          result.todayStage = currentEvent;
        }

        if (lastEvent != currentEvent) {
          if (lastEvent != null) {
            result.stages[currentEvent] = currentDate;
          }
          lastEvent = currentEvent;
        }

        if (result.sum! > targetBbch) {
          result.events[currentDate] = ['Predicted Harvest Date', 'Harvest time! Pick red berries for high quality coffee','Manage your trees! Prune to avoid big coffee trees'];
          result.harvestDate = currentDate;
          break;
        }




        if(speciesData['58'] < remainingBbch && remainingBbch < speciesData['57'] && flags[0] == 0){
          result.events[currentDate]!.add('Avoid spraying of insecticides! You might kill the pollinators. Flowering is coming up!');
          result.tips[0] = currentDateString;
          flags[0] = 1;
        }
        if(speciesData['74'] < remainingBbch && remainingBbch < speciesData['73'] && flags[1] == 0){
          result.events[currentDate]!.add('Coffee Berry Borers may attack your berries. Keep the farm free of ripe berries that may host CBB');
          result.events[currentDate]!.add('Observe for Coffee Brown-eye spot on the berries and leaves');
          result.tips[1] = currentDateString;
          result.tips[2] = currentDateString;
          flags[1] = 1;
        }
        if(speciesData['83'] < remainingBbch && remainingBbch < speciesData['84'] && flags[2] == 0){
          result.events[currentDate]!.add('It\'s almost harvest time');
          flags[2] = 1;
        }
      }
    }

    if (result.firstDayFound == null) {
      result.daysLeft = 0;
      return result;
    }

    if (result.harvestDate == null) {
      result.daysLeft = 0;
      return result;
    }

    DateTime now = DateTime.now();
    Duration duration = result.harvestDate!.difference(DateTime(now.year, now. month, now.day));
    result.daysLeft = duration.inDays<0? 0: duration.inDays;

    for (final stage in this.stages) {
      result.finishedStages.add(stage);

      if(stage == result.todayStage) {
        print('======================');
        print(result.todayStage);
        print('======================');
        break;
      }
    }

    return result;
  }

}