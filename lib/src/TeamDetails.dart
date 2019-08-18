import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:svpullach/src/Team.dart';

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

  WebController webController;

  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadData(widget.team.standings);
    this.webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    this.webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
  }
  @override
  Widget build(BuildContext context) {
    FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
        onWebCreated: onWebCreated
    );
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
                  child: flutterWebView,
                  height: 600.0,
                  width: 500.0,
                ),
              ],
            ),
          );
  }


  @override
  initState() {
  // get the teams table from nuliga if not already loaded and story into team
    widget.team.getStandings();

  }

}