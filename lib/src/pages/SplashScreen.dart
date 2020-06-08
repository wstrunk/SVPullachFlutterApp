import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:svpullach/src/Widgets/SvpScaffold.dart';
import 'package:svpullach/src/pages/login/login.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  WebViewController _controller;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
//      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return new SvpScaffold(
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                child: WebView(
                  initialUrl: 'about:blank',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                    _loadHtmlFromAsset();
                  },
                ),
                height: 600.0,
                width: 500.0,
              ),
            ],
          ),
        )
    );
  }


  _loadHtmlFromAsset() async {
    String fileText = await  rootBundle.loadString('assets/about.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

}



