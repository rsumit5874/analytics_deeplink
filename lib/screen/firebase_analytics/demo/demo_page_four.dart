import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class DemoPageFour extends StatefulWidget {
  const DemoPageFour({Key? key}) : super(key: key);

  @override
  _DemoPageFourState createState() => _DemoPageFourState();
}

class _DemoPageFourState extends State<DemoPageFour>  with SingleTickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Demo Page 4')),
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
      screenName: 'DemoPageFour',
    );
  }
}
