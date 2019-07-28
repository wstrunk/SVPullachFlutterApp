import 'package:flutter/material.dart';
import 'package:flutter_app/src/Widgets/SvpDrawer.dart';

class SvpScaffold extends StatelessWidget {

  final Widget body;

  SvpScaffold({this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: body,
        appBar: AppBar(
          title: Text('SV Pullach Handball'),
          backgroundColor: Colors.yellow,
          actions: <Widget>[
          ],
          leading: new Container(),
        ), endDrawer: SvpDrawer()

    );
  }
}