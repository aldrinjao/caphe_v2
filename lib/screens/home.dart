import 'package:flutter/material.dart';
import 'package:caphe_v2/widgets/drawer.dart';
import 'package:caphe_v2/widgets/circle_tracker.dart';
import 'package:caphe_v2/widgets/tab_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caphe_v2/models/calculator.dart';
import 'package:caphe_v2/widgets/calendar.dart';
import 'package:caphe_v2/widgets/question_dialog.dart';
import 'package:caphe_v2/widgets/feedback.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Calendar',
      style: optionStyle,
    ),
    // Text(
    //   'Index 2: School',
    //   style: optionStyle,
    // ),
    Text(
      'Index 3: School',
      style: optionStyle,
    )
  ];

  //FIRESTORE
  final db = FirebaseFirestore.instance.collection('users');

  //BOTTOM NAVIGATION
  int lastTab = 0;
  int selectedPos = 0;

  //TAB NAVIGATION
  TabController? tabController;

  //DATA
  DocumentSnapshot? weather;

  @override
  void initState() {
    super.initState();
    //FOR BOTTOM NAVIGATION
    // _navigationController = new CircularBottomNavigationController(selectedPos);
    //GETTING DATA
    getWeatherData();
  }

  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);

    // print('aaa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerContainer(user: widget.user),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: <Widget>[
                    Text(
                      "CAPHE",
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    Text(
                      "Coffee Harvest Date Estimator",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
              onPressed: () {
                setState(() {
                  scrollDown();
                  _selectedIndex = 0; //this is so it goes back to home
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            Image.asset(
              'assets/logos/sarai.png',
              fit: BoxFit.contain,
              height: 25,
            ),
            Image.asset(
              'assets/logos/dost-pcaarrd-uplb.png',
              fit: BoxFit.contain,
              height: 25,
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<DocumentSnapshot>(

          // stream: db.collection('users').
          stream: db.doc(widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              //return Text(snapshot.data['records'].toString());
//                return process(context, snapshot.data);
//              return _buildBody(context, snapshot.data);
              return FutureBuilder(
                  future: Future.wait([
                    getWeatherData(),
                  ]),
                  builder: (_, futureSnapshot) {
                    if (futureSnapshot.hasData) {
                      return _buildBody(snapshot.data!);
                    } else {
                      return Center(
                          child: Container(child: CircularProgressIndicator()));
                    }
                  });
            } else {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
          }),
      bottomNavigationBar: bottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: addValue,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  void scrollDown() {
    // Flushbar(
    //   message: "Scrolldown to see the timeltimeline",
    //   icon: Icon(
    //     Icons.info_outline,
    //     size: 28.0,
    //     color: Colors.blue[300],
    //   ),
    //   padding: EdgeInsets.all(8),
    //   borderRadius: 8,
    //   duration: Duration(seconds: 3),
    // )..show(context);
  }

  //BOTTOM NAVIGATION
  Widget bottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // This is all you need!
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: 'Calendar',
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Notes')
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green[800],
      onTap: _onItemTapped,
    );
  }

//this instigates the creation of a new plantation.
  void addValue() async {
    final String? name = await _asyncInputDialog(context);
    // setState(() {});

    tabController!.animateTo(0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String?> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return QuestionDialog(
          //this is the dialog that asks for the name and location
          user: widget.user,
          weather: weather!,
        );
      },
    );
  }

  void setIndex(index) {
    // print(lastTab);
  }

  Widget _buildBody(DocumentSnapshot snapshot) {
    var records = (snapshot != null && snapshot['records'] != null)
        ? snapshot["records"].reversed.toList()
        : [];

    tabController = new TabController(vsync: this, length: records.length);
    // if (records.length > 2) {
    //   tabController!.animateTo(1);
    //   Future.delayed(const Duration(seconds: 2), () {
    //     tabController!.animateTo(0);
    //
    //   });
    // }

    return new Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "Plantation Names",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      TabBarContainer(
          controller: tabController,
          colors: [Colors.white, Colors.blue, Colors.green],
          items: new List<Widget>.from(records
              .map((data) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(data['name'].toString())))
              .toList())),
      Expanded(
        child: records.length == 0
            ? Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                  "Press the + button below to add your first record",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 40.0),
                )))
            : TabBarView(
                controller: tabController,
                children: elementsContainer(_selectedIndex, records)),
      )
    ]);
  }

  List<Widget> elementsContainer(int selectedPos, records) {
    var calculator = Calculator(weatherData: weather);
    List<Widget> result;
    switch (_selectedIndex) {
      case 0:
        {
          result = new List<Widget>.from(records.map((data) {
            var calculatorResult = calculator.getResult(data);
            return CircleTracker(
                dates: calculatorResult.stages,
                harvest: calculatorResult.harvestDate,
                daysLeft: calculatorResult.daysLeft,
                finishedStages: calculatorResult.finishedStages,
                species: data['species'],
                tips: calculatorResult.tips);
          }).toList());
        }
        break;
      case 1:
        {
          result = new List<Widget>.from(records.map((data) {
            var calculatorResult = calculator.getResult(data);
            return TableEventsExample(
              calculatorResult: calculatorResult.tips,
              dates: calculatorResult.stages,
              harvestdate: calculatorResult.harvestDate,
            );
          }).toList());
        }

        break; //Text(data['bbch'].toString())

      case 2:
        {
          result = new List<Widget>.from(records.map((data) => FeedbackForm(
              userId: widget.user.uid, farmName: data['name'].toString())));
        }
        break;

      default:
        result = [Container(color: Colors.black)];
    }
    return result;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _navigationController.dispose();
  // }

  Future<DocumentSnapshot?> getWeatherData() async {
    var document =
        FirebaseFirestore.instance.collection("model").doc("weatherData").get();
    this.weather = await document;
    return this.weather;
  }
}
