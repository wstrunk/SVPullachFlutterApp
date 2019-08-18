import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements


class Team {

  static String nuLigaUrl = "https://bhv-handball.liga.nu";

  static String teamBaseUrl = nuLigaUrl  + "/cgi-bin/WebObjects/nuLigaHBDE.woa/wa/groupPage?";

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
  String standings = "";

  String training1;
  String training2;

  String url;

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

    if (snapshot.data.containsKey('nuliga-url')){
      url = snapshot.data['nuliga-url'];
    }

  }


  String getStandings() {
    if (this.standings.isNotEmpty) {
      return this.standings;
    }
    else {
      initiate();
      return this.standings ;
    }
  }

  Future initiate() async {
    var client = Client();
    String completeUrl = teamBaseUrl + url;

    String standingsContent = getPageHead();
    standingsContent += "<body>";


    Response response = await client.get(completeUrl);
    // Use html parser and query selector
    var document = parse(response.body);

    List elements = document.getElementsByClassName("result-set");
    if (elements.isNotEmpty) {
      standingsContent += "<table class=\"result-set\" cellpadding=\"0\" border=\"0\" cellspacing=\"0\">";
      standingsContent += elements.elementAt(0).outerHtml;
      standingsContent += "</table>";
      standingsContent += "<script>";
      standingsContent += "javascript:show_hide_column(3, false);";
      standingsContent += "javascript:show_hide_column(4, false);";
      standingsContent += "javascript:show_hide_column(5, false);";
      standingsContent += "javascript:show_hide_column(6, false);";
      standingsContent += "javascript:show_hide_column(7, false);";
      standingsContent += "javascript:show_hide_column(8, false);";
      standingsContent += "</script>";
    }

    standingsContent += "</body>";

    this.standings = standingsContent;
  }

   String getPageHead() {
    String result = "<html lang=\"de-DE\">";
    result += "<head> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
    result += "<link rel=\"stylesheet\" type=\"text/css\" media=\"screen\" href=\""
        + nuLigaUrl + "/sources/interface.css?23457324\" />";
    result += "<link rel=\"stylesheet\" type=\"text/css\" media=\"all\" href=\""
        + nuLigaUrl  + "/sources/default.css?23457324\" />";
    result += "<link rel=\"stylesheet\" type=\"text/css\" media=\"screen\" href=\""
        + nuLigaUrl  + "/sources/template.css?23457324\" />";

    // the following js code removes some columns from the tables
    result += "<script src=\"http://code.jquery.com/jquery-latest.js\" type=\"text/javascript\"></script>";
    result += "<script type=\"text/javascript\">";
    result += "function show_hide_column(col_no, do_show) {";
    result += "var stl;";
    result += "if (do_show) stl = 'block';";
    result += "else         stl = 'none';";
    result += "var tbl  = document.getElementsByClassName('result-set');";
    result += "var rows = tbl[0].getElementsByTagName('tr');";
    result += "var headers = rows[0].getElementsByTagName('th');";
      result += "headers[col_no].style.display=stl;";

    result += "for (var row=1; row<rows.length;row++) {";
    result += "var cels = rows[row].getElementsByTagName('td');";
    result += "cels[col_no].style.display=stl;";
    result += "    }";
    result += "  }";
    result += "</script>";

    result += "</head>";
    return result;
  }
}
