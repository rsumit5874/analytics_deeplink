import 'dart:io';

import 'package:analytics_deeplink/screen/firebase_analytics/analytics_home/analytics_demo.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import '../../../main.dart';

class AnalyticsHome extends StatefulWidget {
  const AnalyticsHome({Key? key}) : super(key: key);

  @override
  _AnalyticsHomeState createState() => _AnalyticsHomeState();
}

class _AnalyticsHomeState extends State<AnalyticsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                await MyApp.analytics
                    .setUserProperty(name: 'experience_level', value: 'Expert');

                final id = await getDeviceId();

                await MyApp.analytics.setUserId(
                    id: id, callOptions: AnalyticsCallOptions(global: false));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnalyticsDemoPage()));
              },
              child: const Text('Expert Level'),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                final id = await getDeviceId();
                await MyApp.analytics.setUserProperty(
                    name: 'experience_level', value: 'Beginner');

                await MyApp.analytics.setUserId(
                    id: id, callOptions: AnalyticsCallOptions(global: false));

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnalyticsDemoPage()));
              },
              child: const Text('Beginner'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<String> getDeviceId() async {
    String? deviceId;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceId = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return deviceId ?? '';
  }
}
