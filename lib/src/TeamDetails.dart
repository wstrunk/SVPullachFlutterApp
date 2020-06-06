import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svpullach/src/Team.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails ({
    @required this.team,
    Key key,
  })  : assert(team != null),
        super(key: key);

  final Team team;

  @override
  TeamDetailsState createState() => TeamDetailsState();
}

class TeamDetailsState extends State<TeamDetails> {

  static const double edgeInsetLeft = 16.0;
  static const double edgeInsetBottom = 10.0;

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return
      new Scaffold(
        appBar: AppBar(
            title: Text('${widget.team.teamName}'),
          backgroundColor: Colors.yellow,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: IconButton(
                  icon: const Icon(Icons.email, size: 30.0),
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
          body:
          ListView  (
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: edgeInsetLeft, top: edgeInsetBottom),
                        child: Text(
                          widget.team.teamName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: edgeInsetLeft, top: edgeInsetBottom),
                        child: Text(
                          widget.team.training1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: edgeInsetLeft, top: edgeInsetBottom),
                        child: Text(
                          widget.team.getTrainerList(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
          );
  }

  _loadHtmlFromAssets() async {
    _controller.loadUrl( Uri.dataFromString(
        widget.team.getStandings(),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
  @override
  initState() {
  // get the teams table from nuliga if not already loaded and story into team
    widget.team.getStandings();

  }

}