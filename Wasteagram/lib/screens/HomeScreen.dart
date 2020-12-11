import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:Wasteagram/screens/ViewItem.dart';
import 'package:Wasteagram/screens/AddItem.dart';
import 'package:Wasteagram/main.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: analytics);
  int total; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BarBuild(context),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _buildAppBody(context),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepOrange,
        child: Container(height: 50.0),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.orangeAccent,
            onPressed: () {
              _addingPost();
              Navigator.of(context).pushNamed('/additem');
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _addingPost() async{
    await analytics.logEvent(
      name: 'Add_Post',
        parameters: <String, dynamic>{
          'string': 'string',
          'int': 42,
        }
    );   
    print('success');
  }

  //
  Widget _buildAppBody(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data.documents.length == 0)
            return _circleIndicator(context);
          else {
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildPostList(context, snapshot.data.documents[index]),
            );
          }
        });
  }

  Widget _circleIndicator(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 300),
          ),
          SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrangeAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 10,
              ),
              height: 75,
              width: 75),
        ],
      ),
    );
  }

  Widget _buildPostList(BuildContext context, DocumentSnapshot document) {
    final postInfo = FoodWastePost.fromFirestore(document);
    if(total == null){
      total = 0;
    } else{
      total = total + postInfo.quantity;
    }
    return ListTile(
      title: Text(postInfo.date, style: TextStyle(fontSize: 20)),
      trailing: Text('${postInfo.quantity}'),
      onTap: (){
        Navigator.pushNamed(context, ViewItem.routeName, arguments: postInfo);
      },
    );
  }

  Widget BarBuild(BuildContext context){
    return StreamBuilder(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot){
          total = 0;
          if(snapshot.hasData){
            for(int i = 0; i < snapshot.data.documents.length; i++){
              total = total + snapshot.data.documents[i]['quantity'];
            }
            return Text('WasteaGram - Total Waste: $total', style: TextStyle(fontSize: 20, color: Colors.deepOrange)
            );
          } else {
            return Text('WasteaGram', style: TextStyle(fontSize: 32, color: Colors.deepOrange));
          }
        }
    );
  }
}

class FoodWastePost{
    int quantity;
    String url;
    GeoPoint latitude;
    GeoPoint longitude;
    String date;

    FoodWastePost({this.date, this.url, this.quantity, this.latitude, this.longitude});

    factory FoodWastePost.fromFirestore(DocumentSnapshot document){
      return FoodWastePost(
        quantity: document['quantity'],
        date: document['date'],
        url: document['url'],
        latitude: document['location'],
        longitude: document['location'],
      );
    }

    
}



