import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class DemoPageOne extends StatefulWidget {
  const DemoPageOne({Key? key}) : super(key: key);

  @override
  _DemoPageOneState createState() => _DemoPageOneState();
}

class _DemoPageOneState extends State<DemoPageOne>  with SingleTickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Demo Page 1')),
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
      screenName: 'DemoPageOne',
    );
  }
}
