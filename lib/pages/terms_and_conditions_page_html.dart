import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class HelpScreen extends StatefulWidget {
  @override
  HelpScreenState createState() {
    return HelpScreenState();
  }
}

class HelpScreenState extends State<HelpScreen> {
  WebViewController _controller;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;


//  final Completer<WebViewController> _controller =
//      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
////        title: Text('الشروط والأحكام'),
//        backgroundColor: Colors.brown,
//      ),
      body:
//      InAppWebView(
//        initialUrl: "https://flutter.io/",
//        initialHeaders: {},
//        initialOptions: {},
//        onWebViewCreated: (InAppWebViewController controller) {
//          webView = controller;
//        },
//        onLoadStart: (InAppWebViewController controller, String url) {
//          print("started $url");
//          setState(() {
//            this.url = url;
//          });
//        },
//        onProgressChanged: (InAppWebViewController controller, int progress) {
//          setState(() {
//            this.progress = progress / 100;
//          });
//        },
//      ),

      WebView(
        initialUrl: 'assets/terms_and_conditions.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
//          _controller.complete(webViewController);
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/terms_and_conditions.html');
    _controller.loadUrl(Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

}
