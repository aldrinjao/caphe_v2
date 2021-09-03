import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget{
  @override

  final String _filename;
  final String _name;
  final VoidCallback _onTap;


  ItemCard(this._filename, this._name, this._onTap);

  Widget build(BuildContext context) {
    return new Material(
        child: new InkWell(
          onTap: () => _onTap(),
          child: FittedBox(fit: BoxFit.scaleDown, child: Column(
            children: <Widget>[
              new Text(_name, style: TextStyle(fontSize: 33.0, fontWeight: FontWeight.w200,),),
              new Center(
                child: new Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(_filename,
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(5),
                ),
              ),
            ],
          ),
        ),
        ),
    );

  }
}

