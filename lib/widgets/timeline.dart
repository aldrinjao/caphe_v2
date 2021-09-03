import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BerryTimeline extends StatelessWidget {
  BerryTimeline(
      {Key? key,
      required this.title,
      required this.finishedStages,
      required this.remainingStages,
      required this.harvest,
      required this.species,
      required this.tips})
      : super(key: key);

  final String title;
  final Set<String> finishedStages;
  final Map<String, DateTime> remainingStages;
  final DateTime harvest;
  final String species;
  final List tips;

  var dateFormatter1 = new DateFormat('MMM dd');
  var dateFormatter2 = new DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
  // print(111);
  // print(tips);
    return Center(
      child: Column(
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF66BB6A),
              padding: EdgeInsets.all(6),
            ),
            endChild: _RightChild(
              asset: 'assets/' + species + '/inflorescence.jpeg',
              title: 'Inflorescence',
              message: 'Started',
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF42A5F5),
              padding: EdgeInsets.all(6),
            ),
            endChild: _RightChild(
              asset: 'assets/' + species + '/flowering.jpeg',
              title: 'Flowering',
              message: createMessage('flowering'),
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFFAB47BC),
              padding: EdgeInsets.all(6),
            ),
            endChild: _RightChild(
              asset: 'assets/' + species + '/berrydevelopment.jpeg',
              title: 'Berry Development',
              message: createMessage('berry development'),
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
            afterLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFFEF5530),
              padding: EdgeInsets.all(6),
            ),
            endChild: _RightChild(
              asset: 'assets/' + species + '/berryripening.jpeg',
              title: 'Berry Ripening',
              message: createMessage('berry ripening'),
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
            afterLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFFEF5530),
              padding: EdgeInsets.all(6),
            ),
            endChild: _RightChild(
              asset: 'assets/species/arabica.jpeg',
              title: 'Estimated Harvest Week',
              message: dateFormatter1
                      .format(harvest.subtract(const Duration(days: 3)))
                      .toString() +
                  ' to ' +
                  dateFormatter2
                      .format(harvest.add(const Duration(days: 3)))
                      .toString(),
            ),
            beforeLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          )
        ],
      ),
    );
  }

  String createMessage(String stage) {
    String message = finishedStages.contains(stage)
        ? 'Started'
        : dateFormatter1
                .format(
                    remainingStages[stage]!.subtract(const Duration(days: 3)))
                .toString() +
            ' to ' +
            dateFormatter2
                .format(remainingStages[stage]!.add(const Duration(days: 3)))
                .toString();

    return message;
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key? key,
    required this.asset,
    required this.title,
    required this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
