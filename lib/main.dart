import 'dart:async';

import 'package:analytics_deeplink/home_page.dart';
import 'package:analytics_deeplink/screen/firebase_analytics/analytics_home/analytics_home.dart';
import 'package:analytics_deeplink/screen/firebase_analytics/test_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey:
              'AAAAYSxDh10:APA91bFpukgdpzew1hSFh6NAuognAiTp0xDZqSRJXBoqG-EVhu_JTEkAydROLCdm9t5uqfrv0LfJUZDLc_kzykpm8TXF_0zLXzkjc0xazkmNRVgNi-mdsLIjO6NsacpzsJht8LhyaOFU',
          authDomain: 'deeplink-analytics.firebaseapp.com	',
          databaseURL: 'https://deeplink-analytics-default-rtdb.firebaseio.com',
          projectId: 'deeplink-analytics',
          storageBucket: 'deeplink-analytics.appspot.com',
          messagingSenderId: '417354450781',
          appId: '1:417354450781:android:98f53bfc62686cff7c4ab4',
          measurementId: '',
        ),
        name: 'primary-app');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Analytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: const AnalyticsHome(),
    );
  }
}
