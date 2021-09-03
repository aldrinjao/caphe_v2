import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                child: Container(
                  child: Center(child: _buildContainer()),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.rotate_right,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Legend"),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildItem(Colors.green[400], "inflorescence"),
                    _buildItem(Colors.blue[400], "flowering"),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildItem(Colors.purple[400], "berry development"),
                  _buildItem(Colors.red[400], "berry ripening"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(color, stage) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.brightness_1,
            color: color,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(stage),
          ),
        ],
      ),
    );
  }
}
