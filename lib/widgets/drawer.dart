import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caphe_v2/screens/welcome.dart';
import 'package:caphe_v2/screens/managing.dart';
import 'package:caphe_v2/screens/about.dart';

class DrawerContainer extends StatefulWidget {
  const DrawerContainer({Key? key,required this.user}) : super(key: key);
  final User user;
  @override
  _DrawerContainerState createState() => _DrawerContainerState();
}

class _DrawerContainerState extends State<DrawerContainer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green, Colors.blue])),
            accountEmail: Text(widget.user.email.toString()[0]), // Displays email of user
            accountName: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.hasError){
                  return(Text("Error: ${snapshot.error}"));
                }
                switch(snapshot.connectionState){
                  case ConnectionState.waiting: return Text('Loading..');
                  default:
                    return Text(snapshot.data!['name']);  //Displays name of user
                }
              },
            ),
            currentAccountPicture: CircleAvatar(
              child: Text(
                widget.user.email.toString()[0], // Displays first letter of email
                style: TextStyle(fontSize: 40.00),
              ),
            ),
          ),
          ListTile(
            title: Text('Manage Plantations'),
            trailing: Icon(Icons.collections_bookmark),
            onTap: () async{
              Navigator.of(context).pop(); //this pops the drawer
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PlantationManager(user: widget.user)));
            },
          ),
          ListTile(
            title: Text('About Us'),
            trailing: Icon(Icons.info),
            onTap: () async {
              await Navigator.maybePop(context);
              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AboutScreen()));
              // Removed setState(), the page will be rebuilt automatically
            },
          ),

          ListTile(
            title: Text('Log Out'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              _showDialog();
            },
          ),

        ],
      ),
    );
  }

  //Firebase Authentication logout return to welcome screen.
 Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut().then((_) {

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
              (Route<dynamic> route) => false);
    });
  }

  //Alert Dialog to ask user if they really want to logout
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Leaving so soon!"),
          content: new Text("Are you sure you want to log-out of your account?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Log Out"),
              onPressed: () => _signOut(),
            ),
          ],
        );
      },
    );
  }

  }

