import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/Team.dart';
import 'package:flutter_app/src/Widgets/SvpScaffold.dart';

class TeamPage extends StatefulWidget {

  @override
  _TeamPageState createState() => _TeamPageState();


}

class _TeamPageState extends State<TeamPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return SvpScaffold(
      body: Column(
        children: <Widget>[
          _buildContent(context),
        ],
      ),

    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("teams")
            .where("teamVorhanden", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return ListView(
            padding: EdgeInsets.all(16),
            children: snapshot.data.documents
                .map((snap) => _buildCard(context, snap))
                .toList(),
          );
        },
      ),
    );
  }

  static const double edgeInsetLeft = 16.0;
  static const double edgeInsetBottom = 10.0;


  Widget _buildCard(BuildContext context, DocumentSnapshot snapshot) {
    // we should create a team object here
    var aTeam = new Team.fromSnapshot(snapshot);


    return Card(
        elevation: 2.0,
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: edgeInsetLeft,  top: edgeInsetBottom),
                      child: Text(
                        aTeam.teamName,
                        //snapshot.data['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //snapshot.reference.updateData({"isDone": true});
                    },
                    icon: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: edgeInsetLeft,  top: edgeInsetBottom),
                      child: Text(
                        aTeam.training1,
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
                      padding: const EdgeInsets.only(left: edgeInsetLeft,  top: edgeInsetBottom),
                      child: Text(
                        aTeam.getTrainerList(),
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
            ])
    );
  }
}