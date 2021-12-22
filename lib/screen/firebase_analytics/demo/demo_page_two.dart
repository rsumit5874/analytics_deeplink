import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class DemoPageTwo extends StatefulWidget {
  const DemoPageTwo({Key? key}) : super(key: key);

  @override
  _DemoPageTwoState createState() => _DemoPageTwoState();
}

class _DemoPageTwoState extends State<DemoPageTwo>
    with SingleTickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Demo Page 2')),
      body: const Center(
        child: Text(''),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sendCurrentTabToAnalytics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.observer.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    MyApp.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    MyApp.analytics.setCurrentScreen(
      screenName: 'DemoPageTwo',
    );
  }
}
