import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

const _kTestAnalytics = true;

class TestCrashlytics extends StatefulWidget {
  const TestCrashlytics({Key? key}) : super(key: key);

  @override
  _TestCrashlyticsState createState() => _TestCrashlyticsState();
}

class _TestCrashlyticsState extends State<TestCrashlytics> {
  late Future<void> _initializeFlutterFireFuture;

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Crashlytics'),
      ),
      body: FutureBuilder(
        future: _initializeFlutterFireFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                      onPressed: () {
                        FirebaseCrashlytics.instance
                            .setCustomKey('example', 'flutterfire');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Custom Key "example: flutterfire" has been set \n'
                              'Key will appear in Firebase Console once app has crashed and reopened'),
                          duration: Duration(seconds: 5),
                        ));
                      },
                      child: const Text('Key',
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
                        FirebaseCrashlytics.instance
                            .log('This is a log example');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'The message "This is a log example" has been logged \n'
                              'Message will appear in Firebase Console once app has crashed and reopened'),
                          duration: Duration(seconds: 5),
                        ));
                      },
                      child: const Text('Log',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.amber)),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('App will crash is 5 seconds \n'
                              'Please reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Delay crash for 5 seconds
                        sleep(const Duration(seconds: 5));

                        // Use FirebaseCrashlytics to throw an error. Use this for
                        // confirmation that errors are being correctly reported.
                        FirebaseCrashlytics.instance.crash();
                      },
                      child: const Text('Crash',
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Thrown error has been caught \n'
                              'Please crash and reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Example of thrown error, it will be caught and sent to
                        // Crashlytics.
                        throw StateError('Uncaught error thrown by app');
                      },
                      child: const Text('Throw Error',
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Uncaught Exception that is handled by second parameter of runZonedGuarded \n'
                              'Please crash and reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Example of an exception that does not get caught
                        // by `FlutterError.onError` but is caught by
                        // `runZonedGuarded`.
                        runZonedGuarded(() {
                          Future<void>.delayed(const Duration(seconds: 2), () {
                            final List<int> list = <int>[];
                            print(list[100]);
                          });
                        }, FirebaseCrashlytics.instance.recordError);
                      },
                      child: const Text('Async out of bounds',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.amber)),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Recorded Error  \n'
                                'Please crash and reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));
                          throw Error();
                        } catch (e, s) {
                          // "reason" will append the word "thrown" in the
                          // Crashlytics console.
                          await FirebaseCrashlytics.instance.recordError(e, s,
                              reason: 'as an example of fatal error',
                              fatal: true);
                        }
                      },
                      child: const Text('Record Fatal Error',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.amber)),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Recorded Error  \n'
                                'Please crash and reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));

                          throw Error();
                        } catch (e, s) {
                          // "reason" will append the word "thrown" in the
                          // Crashlytics console.
                          await FirebaseCrashlytics.instance.recordError(e, s,
                              reason: 'as an example of non-fatal error');
                        }
                      },
                      child: const Text('Record Non-Fatal Error',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: Text('Loading'));
          }
        },
      ),
    );
  }
}
