// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

var _kEventSource = Map.fromIterable(List.generate(0, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item),
    value: (item) => List.generate(0, (index) => Event('Event $item }')));

var kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final kToday = DateTime.now();
final kFirstDay = DateTime(2021, 1, 1);
final kLastDay = DateTime(2025, 12, 31);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

class TableEventsExample extends StatefulWidget {
  TableEventsExample(
      {Key? key,
      required this.calculatorResult,
      required this.dates,
      required this.harvestdate})
      : super(key: key);
  List<String> calculatorResult;
  Map<String, DateTime> dates;
  DateTime harvestdate;

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void mapEvents(List<String> c) {
    print('222222222');
    List t = [];
    List tips = ['', '', ''];
    c.forEach((element) {
      if (element != 'completed') {
        t = element.split('-');
        print(DateTime.utc(int.parse(t[0]), int.parse(t[1]), int.parse(t[2])));
      }
    });
    print(t);
    print('222222222');
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  void mapTips(d, h) {
    List<List<Event>> tempK = [];
    List<DateTime> tempV = [];
    Map<DateTime, List<Event>> eventMappings = {};
    d.forEach((key, value) {
      List<Event> tempL = [];

      tempL.add(Event(key));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: -3)));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: -2)));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: -1)));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: 0)));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: 1)));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: 2)));
      tempK.add(tempL);
      tempV.add(value.add(const Duration(days: 3)));
    });
    List<Event> tempL = [];
    tempL.add(Event('Harvest Week'));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: -3)));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: -2)));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: -1)));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: 0)));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: 1)));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: 2)));
    tempK.add(tempL);
    tempV.add(h.add(const Duration(days: 3)));



    int i = 0;
    for (i = 0; i < tempV.length; i++) {
      eventMappings[tempV[i]] = tempK[i];
    }
    setState(() {
      kEvents.clear();
      kEvents.addAll(eventMappings);
    });
  }

  @override
  Widget build(BuildContext context) {
    // mapEvents(widget.calculatorResult);
    mapTips(widget.dates, widget.harvestdate);

    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
