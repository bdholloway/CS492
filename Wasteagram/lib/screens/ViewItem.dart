import 'package:Wasteagram/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ViewItem extends StatefulWidget {
  static const routeName = '/viewitem';

  @override
  _ViewItemState createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
  @override
  Widget build(BuildContext context) {
    final FoodWastePost selectedPost =
        ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
        appBar: AppBar(
          title: Text('WasteaGram',
              style: TextStyle(fontSize: 32, color: Colors.deepOrange)),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50)
            ),
            Center(
              child: Text(selectedPost.date, style: TextStyle(fontSize: 25),)
            ),
            Padding(
              padding: EdgeInsets.only(top: 25)
            ),
            SizedBox(
              height: 500,
              width: 350,
            child: Image.network(
              selectedPost.url,
              scale: 0.1,
            ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25)
            ),
            Center(
              child: Column(
                children: [
                  Text('Latitude: ' + '37.4400', style: TextStyle(fontSize: 10)),
                  Text('Longitude:  ' + '122.1400', style: TextStyle(fontSize: 10)),

                ],
                ),
              
            ),

          ],
        )
      );
  }

}
