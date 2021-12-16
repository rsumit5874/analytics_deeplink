import 'package:analytics_deeplink/screen/app_link/app_link.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeepLink extends StatefulWidget {
  const DeepLink({Key? key}) : super(key: key);

  @override
  _DeepLinkState createState() => _DeepLinkState();
}

class _DeepLinkState extends State<DeepLink> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link'),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.blue,
          height: 50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.amber)),
          minWidth: MediaQuery.of(context).size.width - 20,
          child: const Text(
            'Create Dynamic Link',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () async {
            final link = await _createDynamicLink('/deep_link');
            launchWhatsApp(link);
          },
        ),
      ),
    );
  }

  Future<String> _createDynamicLink(String screenPath) async {
    String dynamicLink = 'https://srgallery.page.link/$screenPath';
    String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/modapk-71d4e.appspot.com/o/app_icons%2Fkinemaster.png?alt=media&token=7aaf4692-4dba-4f20-8117-24ac4b1c6df3';
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://srgallery.page.link',
      link: Uri.parse(dynamicLink),
      androidParameters: AndroidParameters(
        packageName: 'com.example.analytics_deeplink',
        minimumVersion: 0,
        fallbackUrl: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.rovio.angrybirds&hl=en'),
      ),
      iosParameters: const IOSParameters(
        bundleId: 'io.invertase.testing',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Sumit Rai',
          description: 'Software engineer || NeoSOFT Technologies',
          imageUrl: Uri.parse(imageUrl)),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    Uri url = shortLink.shortUrl;
    return url.toString();
  }
}
