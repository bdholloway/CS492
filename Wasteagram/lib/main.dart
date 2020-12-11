import 'dart:async';
import 'package:Wasteagram/screens/AddItem.dart';
import 'package:Wasteagram/screens/AddQuantity.dart';
import 'package:Wasteagram/screens/ViewItem.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:Wasteagram/screens/HomeScreen.dart';
import 'package:Wasteagram/screens/AddItem.dart';
import 'package:Wasteagram/screens/AddQuantity.dart';
import 'package:flutter/foundation.dart' as Foundation;

import 'package:sentry/sentry.dart';

//Crash Reporting
const DSN = 'https://8ae4a1d9b7af49b8be55222d4bd9847d@o434090.ingest.sentry.io/5390488';
final SentryClient sentry = SentryClient(dsn: DSN);



void main() {
  FlutterError.onError = (FlutterErrorDetails details){
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  runZoned( () {
    runApp(MyApp());
  }, onError: (error, stackTrace){
    MyApp.reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: analytics);

  static Future<void> reportError(dynamic error, dynamic stackTrace) async{
    //  if(Foundation.kDebugMode){
    //    print(stackTrace);
    //    return;
    //  }
    final SentryResponse response = await sentry.captureException(exception: error,
    stackTrace: stackTrace);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    throw StateError('Extra Credit Error');
    return MaterialApp(
      theme: ThemeData.dark(),
      navigatorObservers: <NavigatorObserver>[observer],
      home: MyStartApp(),
      
    );
  }
}


class MyStartApp extends StatefulWidget {
  @override
  _MyStartApp createState() => _MyStartApp();
}

class _MyStartApp extends State<MyStartApp> {

  var routes = <String, WidgetBuilder>{
    HomeScreen.routeName: (BuildContext context) => HomeScreen(),
    AddItem.routeName: (BuildContext context) => AddItem(),
    ViewItem.routeName: (BuildContext context) => ViewItem(),
    AddQuantity.routeName: (BuildContext context) => AddQuantity(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'bandnames',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: routes,
    );
  }
}
