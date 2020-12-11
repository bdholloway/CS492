import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:Wasteagram/screens/AddQuantity.dart';
import 'package:Wasteagram/main.dart';
import 'package:Wasteagram/screens/HomeScreen.dart';


class AddItem extends StatefulWidget {
  static const routeName = '/additem';
  

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: analytics);


  String url;
  File sampleImage;
  LocationData location;
  int quant;
  String formTime;
  String date;

  final formKey = new GlobalKey<FormState>();
  final post = FoodWasteData();

  void initState() {
    super.initState();
    grabLocationTime();
  }

  void grabLocationTime() async {
    var nowTime = DateTime.now();
    var locationService = Location();
    location = await locationService.getLocation();
    setState(() {});
    formTime = formatDate(nowTime, [DD, ', ', MM, ' ', d, ', ', yyyy]);
    
  }

  //From Library
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  //From Camera
  Future takeImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      sampleImage = tempImage;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item',
            style: TextStyle(fontSize: 32, color: Colors.deepOrange)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? (photoGrab()) : enabledUpload(),
      ),
    );
  }

  Column photoGrab() {
    return Column(
      
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(80, 80, 80, 0),
        child: Row(
          children: [
            Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Choose Image From Gallery',
              child: IconButton(
                  icon: Icon(Icons.photo),
                  iconSize: 100,
                  color: Colors.white,
                  splashColor: Colors.purple,
                  onPressed: getImage),
            ),
            SizedBox(
              height: 30,
            ),
            Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Take a picture',
              child: IconButton(
                  icon: Icon(Icons.camera),
                  iconSize: 100,
                  color: Colors.green,
                  splashColor: Colors.purple,
                  onPressed: takeImage),
            ),
          ],
        ),
        ),
        Padding( 
          padding: EdgeInsets.fromLTRB(150, 300, 90, 0),
        child: Row(
          children: [
            Semantics(
                button: true,
                enabled: true,
                onTapHint: 'Cancel',
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  iconSize: 100,
                  color: Colors.red,
                  splashColor: Colors.redAccent,
                  onPressed: () => Navigator.of(context).pop(),
                  
                )),
          ],
        ),
        ),
      ],
    );
  }

  Widget enabledUpload() {
    return Container(
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            Image.file(sampleImage, height: 200.0, width: 500),
            SizedBox(height: 15.0),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Number of Waste Items',
              ),
              validator: (value) => value.isEmpty ? 'Number of Waste Items Cannot be Empty' : null,
              onChanged: (value) {
                setState(() {
                  quant = num.parse(value);
                  
                });
                
              },
            ),
            Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Upload Post',
              child: IconButton(
                  icon: Icon(Icons.update),
                  iconSize: 50,
                  color: Colors.blue,
                  splashColor: Colors.purple,
                  onPressed: saveToFire
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveToFire() async {
    var timeKey = DateTime.now();
    StorageReference postImageRef =
        FirebaseStorage.instance.ref().child("Post Image");
    StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

    var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    post.url = ImageUrl.toString();
    post.date = formTime.toString();
    post.location = GeoPoint(location.latitude, location.longitude);
    post.quantity = quant;
    print(post);
    post.addPost();
    _sendAnalyticsEvent();
    Navigator.of(context).pop();
  }

  Future<void> _sendAnalyticsEvent() async{
    await analytics.logEvent(
      name:'AddPost',
      parameters: <String, dynamic>{
        'day': post.date,
        'amount': post.quantity,
      }
    );
  }

  
}

//Create object to get a posts details
class FoodWasteData {
  String date;
  String url;
  GeoPoint location;
  int quantity;

  FoodWasteData({this.url, this.location, this.quantity, this.date});

  void addPost() {
    Firestore.instance.collection('posts').add({
      'date': this.date,
      'url': this.url,
      'location': this.location,
      'quantity': this.quantity
    });
  }
}



