import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:svpullach/src/ReportFeedService.dart';
import 'package:svpullach/src/Widgets/SvpScaffold.dart';
import 'package:svpullach/src/Widgets/web_view_container';


import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

class ReportPage extends StatefulWidget {

  @override
  _ReportPageState createState() => _ReportPageState();

}

class _ReportPageState extends State<ReportPage> {

  @override
  Widget build(BuildContext context) {
    //final Future<RssFeed> feed =  ReportFeedService().getFeed();

    return SvpScaffold(
      body: FutureBuilder(
        future: ReportFeedService().getFeed(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  final feed = snapshot.data;
                  return ListView.builder(
                      itemCount: feed.items.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        final item = feed.items[index];
                        return ListTile(
                          title: Text(item.title),
                          subtitle: Text("Autor: " + item.dc.creator + "\nveröffentlicht: " + item.pubDate.toString().substring(0,16)
//                              +
//                              DateFormat.yMd()
//                                  .format(DateTime.parse(item.pubDate))
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewContainer(item
                                        .link
                                    //    .replaceFirst('http', 'https')
                                    )));
                          },
                        );
                      });
                }
              }
              break;
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
            default:
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
          }
        },
      ),


    );
  }



  static const double edgeInsetLeft = 16.0;
  static const double edgeInsetBottom = 10.0;

}