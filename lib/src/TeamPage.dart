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

  static const double edgeInset = 8.0;

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
                      padding: const EdgeInsets.all(edgeInset),
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
                      Icons.contacts,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(edgeInset),
                      child: Text(
                        //buildTrainingString(snapshot.data['training1']),
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
                      padding: const EdgeInsets.all(edgeInset),
                      child: Text(
                        aTeam.getTrainerList(),
                        //buildTrainerList(snapshot.data['trainer']),
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

  String buildTrainingString(data) {
    String training = "";

    if (data != null) {
      training = "Training: ";
      Map trainingMap = new Map<String, dynamic>.from(data);
      training = training + trainingMap['day'];
      training = training + ", " + trainingMap['time'];
      training = training + ", " + trainingMap['location'];
    }
    return training;
  }

  String buildTrainerList(value) {
    String trainers = "";
    if (value != null) {
      trainers = "Trainer: ";
      Map trainersMap = new Map<String, dynamic>.from(value);
      trainers = trainers + trainersMap['head'];
      if (trainersMap.containsKey('support1')) {
        trainers = trainers + ", " + trainersMap['support1'];
      }
      if (trainersMap.containsKey('support2')) {
        trainers = trainers + ", " + trainersMap['support2'];
      }
      if (trainersMap.containsKey('support3')) {
        trainers = trainers + ", " + trainersMap['support3'];
      }
    }
    return trainers;
  }
}