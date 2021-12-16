import 'package:analytics_deeplink/tags_pages.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class TestAnalytics extends StatefulWidget {
  const TestAnalytics({Key? key}) : super(key: key);

  @override
  _TestAnalyticsState createState() => _TestAnalyticsState();
}

class _TestAnalyticsState extends State<TestAnalytics> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                'Test logEvent',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: _sendAnalyticsEvent,
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: _testAllEventTypes,
              child: const Text('Test standard event types',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: _testSetUserId,
              child: const Text('Test setUserId',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: _testSetCurrentScreen,
              child: const Text('Test setCurrentScreen',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: _testSetAnalyticsCollectionEnabled,
              child: const Text('Test setAnalyticsCollectionEnabled',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: _testSetSessionTimeoutDuration,
              child: const Text('Test setSessionTimeoutDuration',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.amber)),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: _testSetUserProperty,
              child: const Text('Test setUserProperty',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            Text(
              _message,
              style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<TabsPage>(
              settings: const RouteSettings(name: TabsPage.routeName),
              builder: (BuildContext context) {
                return const TabsPage();
              },
            ),
          );
        },
        child: const Icon(Icons.tab),
      ),
    );
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await MyApp.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
        'items': [itemCreator()]
      },
    );
    setMessage('logEvent succeeded');
  }

  Future<void> _testSetUserId() async {
    await MyApp.analytics.setUserId(id: 'some-user');
    setMessage('setUserId succeeded');
  }

  Future<void> _testSetCurrentScreen() async {
    await MyApp.analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('setCurrentScreen succeeded');
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await MyApp.analytics.setAnalyticsCollectionEnabled(false);
    await MyApp.analytics.setAnalyticsCollectionEnabled(true);
    setMessage('setAnalyticsCollectionEnabled succeeded');
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await MyApp.analytics
        .setSessionTimeoutDuration(const Duration(milliseconds: 20000));
    setMessage('setSessionTimeoutDuration succeeded');
  }

  Future<void> _testSetUserProperty() async {
    await MyApp.analytics.setUserProperty(name: 'regular', value: 'indeed');
    setMessage('setUserProperty succeeded');
  }

  AnalyticsEventItem itemCreator() {
    return AnalyticsEventItem(
      affiliation: 'affil',
      coupon: 'coup',
      creativeName: 'creativeName',
      creativeSlot: 'creativeSlot',
      discount: 2.22,
      index: 3,
      itemBrand: 'itemBrand',
      itemCategory: 'itemCategory',
      itemCategory2: 'itemCategory2',
      itemCategory3: 'itemCategory3',
      itemCategory4: 'itemCategory4',
      itemCategory5: 'itemCategory5',
      itemId: 'itemId',
      itemListId: 'itemListId',
      itemListName: 'itemListName',
      itemName: 'itemName',
      itemVariant: 'itemVariant',
      locationId: 'locationId',
      price: 9.99,
      currency: 'USD',
      promotionId: 'promotionId',
      promotionName: 'promotionName',
      quantity: 1,
    );
  }

  Future<void> _testAllEventTypes() async {
    await MyApp.analytics.logAddPaymentInfo();
    await MyApp.analytics.logAddToCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await MyApp.analytics.logAddToWishlist();
    await MyApp.analytics.logAppOpen();
    await MyApp.analytics.logBeginCheckout(
      value: 123,
      currency: 'USD',
      items: [itemCreator(), itemCreator()],
    );
    await MyApp.analytics.logCampaignDetails(
      source: 'source',
      medium: 'medium',
      campaign: 'campaign',
      term: 'term',
      content: 'content',
      aclid: 'aclid',
      cp1: 'cp1',
    );
    await MyApp.analytics.logEarnVirtualCurrency(
      virtualCurrencyName: 'bitcoin',
      value: 345.66,
    );

    await MyApp.analytics.logGenerateLead(
      currency: 'USD',
      value: 123.45,
    );
    await MyApp.analytics.logJoinGroup(
      groupId: 'test group id',
    );
    await MyApp.analytics.logLevelUp(
      level: 5,
      character: 'witch doctor',
    );
    await MyApp.analytics.logLogin(loginMethod: 'login');
    await MyApp.analytics.logPostScore(
      score: 1000000,
      level: 70,
      character: 'tiefling cleric',
    );
    await MyApp.analytics
        .logPurchase(currency: 'USD', transactionId: 'transaction-id');
    await MyApp.analytics.logSearch(
      searchTerm: 'hotel',
      numberOfNights: 2,
      numberOfRooms: 1,
      numberOfPassengers: 3,
      origin: 'test origin',
      destination: 'test destination',
      startDate: '2015-09-14',
      endDate: '2015-09-16',
      travelClass: 'test travel class',
    );
    await MyApp.analytics.logSelectContent(
      contentType: 'test content type',
      itemId: 'test item id',
    );
    await MyApp.analytics.logSelectPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
    );
    await MyApp.analytics.logSelectItem(
      items: [itemCreator(), itemCreator()],
      itemListName: 't-shirt',
      itemListId: '1234',
    );
    await MyApp.analytics.logScreenView(
      screenName: 'tabs-page',
    );
    await MyApp.analytics.logViewCart(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await MyApp.analytics.logShare(
      contentType: 'test content type',
      itemId: 'test item id',
      method: 'facebook',
    );
    await MyApp.analytics.logSignUp(
      signUpMethod: 'test sign up method',
    );
    await MyApp.analytics.logSpendVirtualCurrency(
      itemName: 'test item name',
      virtualCurrencyName: 'bitcoin',
      value: 34,
    );
    await MyApp.analytics.logViewPromotion(
      creativeName: 'promotion name',
      creativeSlot: 'promotion slot',
      items: [itemCreator()],
      locationId: 'United States',
      promotionId: '1234',
      promotionName: 'big sale',
    );
    await MyApp.analytics.logRefund(
      currency: 'USD',
      value: 123,
      items: [itemCreator(), itemCreator()],
    );
    await MyApp.analytics.logTutorialBegin();
    await MyApp.analytics.logTutorialComplete();
    await MyApp.analytics.logUnlockAchievement(id: 'all Firebase API covered');
    await MyApp.analytics.logViewItem(
      currency: 'usd',
      value: 1000,
      items: [itemCreator()],
    );
    await MyApp.analytics.logViewItemList(
      itemListId: 't-shirt-4321',
      itemListName: 'green t-shirt',
      items: [itemCreator()],
    );
    await MyApp.analytics.logViewSearchResults(
      searchTerm: 'test search term',
    );
    setMessage('All standard events logged successfully');
  }
}
