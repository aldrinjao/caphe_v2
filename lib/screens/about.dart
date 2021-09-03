import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About CAPHE"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8.0),),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('CAPHE', style: TextStyle(color: Colors.green, fontSize: 40.0, fontWeight: FontWeight.w700, letterSpacing: 8 ),),
            ),
            Padding(padding: EdgeInsets.all(8.0),),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('This application is made under Project SARAI that aims for smarter agriculture in the Philippines. The prediction is based on the study of BM Salazar et al. in 2019, "Profiling and Analysis of Reproductive Phenology of Four Coffee species in the Philippines". The SARAI Coffee and Cacao team is headed by Dr. Calixto M. Protacio of Institute of Crop Sciece, College of Agriculure and Food Science, UP Los Banos.', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
            ),
            Padding(padding: EdgeInsets.all(8.0),),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Contact us at:', style: TextStyle(color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.w300 ),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('chitoprotacio@gmail.com \nbongsalazar09@yahoo.com', style: TextStyle(color: Colors.blue, fontSize: 18.0, fontWeight: FontWeight.w300 ),),
            ),
            Padding(padding: EdgeInsets.all(8.0),),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('For program development and other related concerns contact:', style: TextStyle(color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.w300 ),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('clkhan@up.edu.ph \njeynethmariano@gmail.com\naldrinhao@gmail.com ', style: TextStyle(color: Colors.blue, fontSize: 18.0, fontWeight: FontWeight.w300 ),),
            ),
          ],
        ),
      ),
    );
  }
}

