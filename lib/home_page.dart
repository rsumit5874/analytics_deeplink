import 'dart:async';

import 'package:analytics_deeplink/screen/app_link/app_link.dart';
import 'package:analytics_deeplink/screen/app_link/webview_demo.dart';
import 'package:analytics_deeplink/screen/deep_link/deep_link.dart';
import 'package:analytics_deeplink/screen/firebase_analytics/analytics_home/analytics_demo.dart';
import 'package:analytics_deeplink/screen/firebase_analytics/test_analytics.dart';
import 'package:analytics_deeplink/screen/firebase_crashlytics/test_crashlytics.dart';
import 'package:analytics_deeplink/screen/webview/webview_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
    // _checkVersion();
  }

  //dynamic link
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      _showSnackBar(dynamicLinkData.link.path);
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  //--------------

  //App link
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        if (uri != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WebViewDemo(initialUrl: uri.toString())));
        }
      }, onError: (Object err) {
        if (!mounted) return;
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = false;
      _showSnackBar('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          _showSnackBar('Url not found,Try again...');
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WebViewDemo(initialUrl: uri.toString())));
          print('got initial uri: $uri');
        }
        if (!mounted) return;
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        _showSnackBar('failed to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        _showSnackBar('malformed initial uri');
      }
    }
  }

  //-----

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final queryParams = _latestUri?.queryParametersAll.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              child: const Text(
                'Test Analytics',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnalyticsDemoPage()));
              },
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TestCrashlytics()));
              },
              child: const Text('Test Crashlytics',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AppLink()));
              },
              child: const Text('App Link',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const DeepLink()));
              },
              child: const Text('Deep Link',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WebViewExample()));
              },
              child: const Text('WebView Exe',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String msg) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final context = _scaffoldKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
        ));
      }
    });
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.snapchat.android",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status!,
      dialogTitle: "UPDATE!!!",
      dismissButtonText: "Skip",
      dialogText: "Please update the app from " +
          status.localVersion +
          " to " +
          status.storeVersion,
      dismissAction: () {
        SystemNavigator.pop();
      },
      updateButtonText: "Lets update",
    );
  }
}
