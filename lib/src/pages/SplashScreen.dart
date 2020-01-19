import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:svpullach/src/Widgets/SvpScaffold.dart';
import 'package:svpullach/src/pages/login/login.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {


  WebController webController;

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
    FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
      onWebCreated: onWebCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        Factory<OneSequenceGestureRecognizer>(
              () => TapGestureRecognizer(),
        ),
      ].toSet(),
    );

    return new SvpScaffold(
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                child: flutterWebView,
                height: 600.0,
                width: 500.0,
              ),
            ],
          ),
        )
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


  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadData(html);
    this.webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    this.webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
  }

}



