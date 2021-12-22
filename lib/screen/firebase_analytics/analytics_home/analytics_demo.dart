import 'dart:math';

import 'package:analytics_deeplink/screen/firebase_analytics/demo/demo_page_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../demo/demo_page_four.dart';
import '../demo/demo_page_three.dart';
import '../demo/demo_page_two.dart';

class AnalyticsDemoPage extends StatefulWidget {
  const AnalyticsDemoPage({Key? key}) : super(key: key);

  @override
  _AnalyticsDemoPageState createState() => _AnalyticsDemoPageState();
}

class _AnalyticsDemoPageState extends State<AnalyticsDemoPage> {
  var sumOfDice = '';
  var value1 = '';
  var value2 = '';
  var doubles = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Analytics Demo'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'DOUBLES',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      value1 == value2 ? 'Yes' : 'No',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('SUM OF DICE',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$value1 + $value2 = $sumOfDice',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,

              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                var random = Random();
                int randomNumber1 = random.nextInt(10);
                int randomNumber2 = random.nextInt(10);
                int sum = randomNumber1 + randomNumber2;

                await MyApp.analytics.logEvent(
                  name: 'roll',
                  parameters: <String, dynamic>{
                    'sum': sum.toDouble(),
                    'doubles':
                        randomNumber1 == randomNumber2 ? 'true' : 'false',
                  },
                );

                setState(() {
                  sumOfDice = sum.toString();
                  value1 = randomNumber1.toString();
                  value2 = randomNumber2.toString();
                });
              },
              child: const Text('Click'),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,

              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DemoPageOne()));
              },
              child: const Text('Open Page One'),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,

              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DemoPageTwo()));
              },
              child: const Text('Open Page Two'),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,

              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DemoPageThree()));
              },
              child: const Text('Open Page Three'),
            ),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.80,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DemoPageFour()));
              },
              child: const Text('Open Page Four'),
            ),
          ],
        ),
      ),
    );
  }
}
