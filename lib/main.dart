import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:svpullach/src/Widgets/SvpScaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new SvpScaffold(
          body: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: WebView(
                    initialUrl: 'about:blank',
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                      _loadHtmlFromAssets();
                    },
                  ),
                  height: 600.0,
                  width: 500.0,
                ),
              ],
            ),
          )
      ),
    );
  }

  String html = '<body>' +
  '<h1>Sportverein Pullach i. Isartal e.V.</h1>' +
  '<h4>Abteilung Handball im Deutschen Handballbund (DHB)</h4>' +
  '<p>Vereinsregister (Hauptverein): Amtsgericht München, VR 8796</p>' +
  '<p>Gistlstraße. 2, D-82049 Pullach i.Isartal</p>' +
  '<p>Vertretungsberechtigt für den SV Pullach Abt. Handball ist der Vorsitzende<br>' +
  'Dirk Trautmann, Kastanienallee 6, 82049 Pullach<br>' +
  'E-Mail: <a href="mailto:vorstand@svpullach-handball.de">vorstand@svpullach-handball.de</a></p>' +
  '<p>sowie dessen Stellvertreter' +
  'Benedikt Thelen, Wolfratshauser Str. 76, 82049 Pullach<br>' +
  'E-Mail:<span>&nbsp;</span><a href="mailto:benedikt.thelen@svpullach-handball.de">benedikt.thelen@svpullach-handball.de</a></p>' +
  '<h1>Sponsoren</h1>' +
  '<table>' +
  '<tbody>' +
  '<tr>' +
  '<td><a href="https://www.edeka.de/eh/sdbayern/edeka-hltkemeyer-theresienhhe-12/index.jsp" target="_blank" rel="noopener"><img style="display: block; margin-left: auto; margin-right: auto;" src="http://www.svpullach-handball.de/wp-content/uploads/2019/07/Logo-Edeka_Theresie-01.png" width="350"  alt="" /></a></td>' +
  '</tr>' +
  '<tr>' +
  '<td><a href="https://www.allfinanz.ag/Oliver.Muehldorfer/index.html" target="_blank" rel="noopener"><img src="http://www.svpullach-handball.de/wp-content/uploads/2019/07/oliver_muehldorfer_logo.png" alt="" width="350" height="175" /></a></td>' +
  '</tr>' +
  '<tr style="text-align: center;">' +
  '<td><a href="www.weplayhandball.de" target="_blank" rel="noopener"><img style="display: block; margin-left: auto; margin-right: auto;" src="http://www.svpullach-handball.de/wp-content/uploads/2015/01/WPH_Logo.jpg" alt="" /></a></td>' +
  '</tbody>' +
  '</table>' +
      '</body>'  ;


  _loadHtmlFromAssets() async {
    _controller.loadUrl( Uri.dataFromString(
        html,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

//  void onWebCreated(webController) {
//    this.webController = webController;
//    this.webController.loadUrl("https://www.amazon.com");
//    this.webController.onPageStarted.listen((url) =>
//        print("Loading $url")
//    );
//    this.webController.onPageFinished.listen((url) =>
//        print("Finished loading $url")
//    );
//  }
}