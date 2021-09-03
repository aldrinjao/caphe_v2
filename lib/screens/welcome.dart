import 'package:flutter/material.dart';
import 'package:caphe_v2/widgets/tab_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:caphe_v2/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{
  //TAB NAVIGATION
  late TabController tabController;

  final db = FirebaseFirestore.instance;
  String _errorMessage = "";

  List<Widget> _tabs = [
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text("Existing"),
    ),
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text("New"),
    ),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late String _email, _password, _displayName;

  @override
  Widget build(BuildContext context) {
    TabController tabController =
    new TabController(vsync: this, length: 2, initialIndex: 0);

    Widget _showErrorMessage() {
      if (_errorMessage.length > 0) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.warning, color: Colors.red,),
              ),
              Expanded(
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return new SizedBox();
      }
    }



    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft)),
        child: Column(
          children: <Widget>[
            Flexible(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/logos/sarai_coffee.png',
                      height: 1000,
                    ))),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 5),
              child: TabBarContainer(
                controller: tabController,
                items: _tabs,
                colors: [Colors.black, Colors.white, Colors.white ],
              ),
            ),
            Expanded(
              flex: 3,
              child: TabBarView(

                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.all(20),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return 'Provide an email';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'user@gmail.com',
                                      icon: new Icon(
                                        Icons.mail,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Email'),
                                  onSaved: (input) => _email = input!,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input!.length < 6) {
                                      return 'Longer password please';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      icon: new Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Password'),
                                  onSaved: (input) => _password = input!,
                                  obscureText: true,
                                ),
                              ),
                              _showErrorMessage(),
                              ElevatedButton(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                // color: Colors.blue,
                                onPressed: signIn,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.all(20),
                      child: Form(
                          key: _formKey2,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  maxLines: 1,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return 'Provide an name';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Jane Doe',
                                      icon: new Icon(
                                        Icons.person_outline,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Name'),
                                  onSaved: (input) => _displayName = input!,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return 'Provide an email';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'user@gmail.com',
                                      icon: new Icon(
                                        Icons.mail,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Email'),
                                  onSaved: (input) => _email = input!,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input!.length < 6) {
                                      return 'Longer password please';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      icon: new Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Password'),
                                  onSaved: (input) => _password = input!,
                                  obscureText: true,
                                ),
                              ),
                              _showErrorMessage(),
                              ElevatedButton(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                // color: Colors.blue,
                                onPressed: () {signUp(context);},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );


  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user.user as User)),
                (Route<dynamic> route) => false);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
        print(e.toString());
      }
    }
  }

  void successSnackBar(){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(title: Text("Congratulations! You've created a CAPHE account.",), actions: <Widget>[
            ElevatedButton(child: Text("Continue"), onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));},)
          ],);
          //
        });

  }

  void signUp(BuildContext context) async {
    if (_formKey2.currentState!.validate()) {
      _formKey2.currentState!.save();
      try {
        UserCredential user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password));
        await db
            .collection('users')
            .doc(user.user!.uid)
            .set({'name': _displayName, 'records':[]});

        successSnackBar();
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
        print(e.toString());
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
