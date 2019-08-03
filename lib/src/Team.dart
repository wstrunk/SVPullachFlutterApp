import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Team {
  Team({@required this.teamName,
    this.trainer,
    this.eMail,
    @required this.training1,
    })
      : assert(teamName != null),
        assert(trainer != null),
        assert(training1 != null);

  String teamName;
  String eMail;
  String trainer;
  List<String> additionalTrainer = new List();

  String training1;
  String training2;

  String getTrainerList (){
    String trainers = "Trainer: ";
    trainers = trainers + trainer;

    if (additionalTrainer.isNotEmpty) {
      additionalTrainer.forEach((subtrainer) =>
      trainers = trainers + ", " + subtrainer);
    }
     return trainers;
  }

  Team copyWith(
      {String teamName, String eMail, String trainer, String training1}) {
    return Team(
      teamName: teamName ?? this.teamName,
      trainer: trainer ?? this.trainer,
      training1: training1 ?? this.training1,
        eMail: eMail?? this.eMail,
    );
  }
  Team.fromSnapshot(DocumentSnapshot snapshot){
    teamName = snapshot.data['name'];
    Map trainersMap = new Map<String, dynamic>.from(snapshot.data['trainer']);
    trainer = trainersMap['head'];
    eMail = snapshot.data['email'];

    if (trainersMap.containsKey('support1')) {
      additionalTrainer.add(trainersMap['support1']);
    }
    if (trainersMap.containsKey('support2')) {
      additionalTrainer.add(trainersMap['support2']);
    }
    if (trainersMap.containsKey('support3')) {
      additionalTrainer.add(trainersMap['support3']);
    }

    Map trainingMap = new Map<String, dynamic>.from(snapshot.data['training1']);
    training1 = "Training: ";
    training1 = training1 + trainingMap['day'];
    training1 = training1 + ", " + trainingMap['time'];
    training1 = training1 + ", " + trainingMap['location'];

    if (snapshot.data.containsKey('training2')){
    trainingMap = new Map<String, dynamic>.from(snapshot.data['training2']);
      training2 = "Training: ";
      training2 = training2 + trainingMap['day'];
      training2 = training2 + ", " + trainingMap['time'];
      training2 = training2 + ", " + trainingMap['location'];
    }
  }
}
