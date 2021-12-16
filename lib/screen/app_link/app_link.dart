
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class AppLink extends StatefulWidget {
  const AppLink({Key? key}) : super(key: key);

  @override
  _AppLinkState createState() => _AppLinkState();
}

class _AppLinkState extends State<AppLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          color: Colors.blue,
          height: 50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.amber)),
          minWidth: MediaQuery.of(context).size.width - 50,
          child: const Text(
            'Share app link',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () {
            launchWhatsApp(
                'https://cryptowire.in/#/news-detail?newsId=NI2134908321004040100000000006');
          },
        ),
      ),
    );
  }
}

launchWhatsApp(String data) async {
  final link = WhatsAppUnilink(
    phoneNumber: '+91-9716754100',
    text: data,
  );
  await launch('$link');
}
