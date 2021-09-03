import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This is the stateful widget that the main application instantiates.
class FeedbackForm extends StatefulWidget {
  const FeedbackForm({Key? key, this.restorationId, this.userId, this.farmName})
      : super(key: key);

  final String? restorationId;
  final String? userId;
  final String? farmName;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// RestorationProperty objects can be used because of RestorationMixin.
class _MyStatefulWidgetState extends State<FeedbackForm> with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;
  final db = FirebaseFirestore.instance;
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  var dateFormatter = new DateFormat('MMM dd, yyyy');
  bool _validate = false;
  TextEditingController? _text;

  void initState() {
    _text = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _text?.dispose();
    super.dispose();
  }

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021, 1, 1),
          lastDate: DateTime(2022, 1, 1),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      _buildLabel(),
      _buildDatePickerRow(),
      _buildTextArea(),
      _buildSave(),
      _buildNote(),
      Padding(padding: EdgeInsets.all(50))
    ]);
  }

  Container _buildDatePickerRow() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('For: ' + dateFormatter.format(_selectedDate.value).toString(),
              style: TextStyle(fontSize: 20)),
          Expanded(
            child: Container(),
          ),
          OutlinedButton(
            onPressed: () {
              _restorableDatePickerRouteFuture.present();
            },
            child: const Icon(Icons.today),
          ),
        ],
      ),
    );
  }

  Container _buildTextArea() {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
                controller: _text,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                //Normal textInputField will be displayed
                maxLines: 5,
                // when user presses enter it will adapt to it
                decoration: InputDecoration(
                  hintText: 'Input here',
                  labelText: 'Notes about this plantation',
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                )),
          ),
        ],
      ),
    );
  }

  Container _buildLabel() {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("Make a Note",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          )
        ],
      ),
    );
  }

  Container _buildSave() {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: ElevatedButton(onPressed: _noteSaved, child: Text('save')))
        ],
      ),
    );
  }

  void _addNote() async {
    try {
      await db.collection('notes').add({
        'user': widget.userId,
        'date': DateTime.now(),
        'noteForDate': _selectedDate.value,
        'farm_name': widget.farmName,
        'note': _text!.text.toString()
      });
    } catch (e) {
      print(e.toString());
    }

    FirebaseFirestore.instance
        .collection('notes')
        .where('farm_name', isEqualTo: widget.farmName)
        .where('user', isEqualTo: widget.userId)
        .snapshots()
        .listen((data) {
      data.docs.map((e) => () {
            print(e);
            print(1);
          });
    });
  }

  Widget _buildNote() {
    var query = FirebaseFirestore.instance
        .collection('notes')
        .where('farm_name', isEqualTo: widget.farmName)
        .where('user', isEqualTo: widget.userId);

    return SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Container(child: CircularProgressIndicator()));

        }
        print(snapshot.data!.docs.length);
        return Column(
            children: List<Widget>.from(snapshot.data!.docs
                .map((doc) => _itemCard(doc.reference.id, doc))).toList());
      },
    ));
  }

//List tile doc passes info about the plantation
  Widget _itemCard(docID, doc) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Note for: ${dateFormatter.format(doc['noteForDate'].toDate())}",
              style: TextStyle(fontSize: 14.0),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Text(
              "${doc['note']}",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Text(
              "Submitted: ${dateFormatter.format(doc['date'].toDate())}",
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () {
              _deleteDoc(docID);
            }),
      ),
    );
  }

  void _deleteDoc(docId) async {
    try {
      db.collection('notes').doc(docId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void _noteSaved() {
    _text!.text.isEmpty ? _validate = true : _validate = false;
    if (_validate) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Note is empty'),
      ));
    } else {
      ///upload to firebase here before making it empty
      try {
        _addNote();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Note saved'),
        ));
        setState(() {
          _text!.text = "";
        });
      } catch (e) {
        print(e);
      }
    }
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
