import 'package:flutter/material.dart';

class TabBarContainer extends StatefulWidget {
  const TabBarContainer({Key? key, this.controller, this.items, required this.colors}) : super(key: key);
  final items;
  final controller;
  final List<Color> colors;
  @override
  _TabBarContainerState createState() => _TabBarContainerState();

}

class _TabBarContainerState extends State<TabBarContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), color: Colors.grey[300]),
      constraints: BoxConstraints(maxHeight: 150.0),
      child: new TabBar(
          controller: widget.controller,
          unselectedLabelColor: Colors.black54,
          labelColor: widget.colors[0],
          isScrollable: true,
          indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), gradient: LinearGradient(colors: [widget.colors[1], widget.colors[2]])),
          tabs: widget.items,
        ),
    );
  }
}
