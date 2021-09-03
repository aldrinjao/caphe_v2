import 'package:caphe_v2/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:caphe_v2/screens/home.dart';
import 'package:caphe_v2/screens/welcome.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();

}



class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user != null) {
            print("user is logged in");
            print(user);
            return HomeScreen(user: snapshot.data as User);
          } else {
            return WelcomeScreen();
          }
        }


        // stream: FirebaseAuth.instance.authStateChanges(),
        // builder: (context, snapshot) {
        //   if (snapshot.connectionState != ConnectionState.active) {
        //     return Center(child: CircularProgressIndicator());
        //   }
        //
        //
        //   if (futureResult.connectionState == ConnectionState.done) {
        //     if (futureResult.hasData) {
        //       return WelcomeScreen();
        //     }
        //     return HomeScreen(user: futureResult.data as User);
        //     // return WelcomeScreen();
        //   }
        //   return Center(child: Container(child: CircularProgressIndicator()));
        // }

    );
  }

}


