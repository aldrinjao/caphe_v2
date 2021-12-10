import 'package:flutter/material.dart';
import 'package:caphe_v2/widgets/item_card.dart';
import 'package:caphe_v2/utils/questionaire_utils.dart';
import 'package:caphe_v2/utils/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionairePage extends StatefulWidget {
  const QuestionairePage(
      {required this.name, required this.user, required this.location});

  final User user;
  final String name;
  final String location;

  @override
  State<StatefulWidget> createState() {
    return QuestionairePageState();
  }
}

class QuestionairePageState extends State<QuestionairePage> {
  final db = FirebaseFirestore.instance;
  late List<Item> currentList;
  var state = 'start';
  Questionaire questionaire = new Questionaire();
  late List<String> messages;
  var i = 0;
  late var kind;

  @override
  void initState() {
    super.initState();
    currentList = questionaire.species;
    kind = 'species';
  }

  @override
  Widget build(BuildContext context) {
    //function to check if it's a number
    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    messages = [
      'Click its species:',
      'Click its current stage:',
      'Click the closest image:'
    ];
    final title = 'Calculate Harvest Date';

    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                //Displays the Direction Text
                child: new Text(
                  messages[i % 3],
                  style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[700]),
                  textAlign: TextAlign.left,
                ),
              ),
              new Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                        currentList.length,
                        (index) {
                          return ItemCard(
                              'assets/' +
                                  kind +
                                  "/" +
                                  currentList[index].location,
                              currentList[index].name,
                              () => this.setState(() {
                                    //this is a callback function when the ItemCard is pressed
                                    i++;
                                    if (i == 1) kind = currentList[index].name;
                                    if (isNumeric(currentList[index].value)) {
                                      Navigator.popUntil(
                                          context,
                                          (Route<dynamic> route) =>
                                              route.isFirst);
                                      print('==========================');
                                      print(currentList.length);
                                      print('===========================');

                                      addValue(
                                          kind,
                                          widget.name,
                                          int.parse(currentList[index].value)+1,
                                          widget.location);
                                    } else {
                                      state = currentList[index].value;
                                      currentList =
                                          questionaire.nextList(state, kind);
                                    }
                                  }));
                        },
                      ),
                    )),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: back,
            backgroundColor: Colors.green,
            child: Icon(Icons.arrow_back),
          )),
    );
  }

  void back() {

    print(i);
    if (i == 0) {
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    } else {
      setState(() {
        i=0;
        currentList = questionaire.species;
        kind = 'species';

      });
    }
  }

  void addValue(String species, String name, int bbch, String location) async {
    try {
      await db.collection('users').doc(widget.user.uid).update({
        "records": FieldValue.arrayUnion([
          {
            'date': DateTime.now(),
            'species': species,
            'location': location,
            'name': name,
            'bbch': bbch
          }
        ])
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
