import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/Widgets/SvpDrawer.dart';
import 'package:flutter_app/src/Widgets/SvpScaffold.dart';

class GameEventPage extends StatefulWidget {

  @override
  _GameEventPageState createState() => _GameEventPageState();


}

class _GameEventPageState extends State<GameEventPage> {
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
    var now = new DateTime.now();
    var dayString = now.day.toString();
    if (dayString.length < 2) { dayString = "0" + dayString ;}
    var monthString = now.month.toString();
    if (monthString.length < 2) { monthString = "0" + monthString;}
    var nowString = dayString  + "." + monthString + "." + now.year.toString();
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("game_events")
            .where("day", isGreaterThanOrEqualTo: nowString)
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

  Widget _buildCard(BuildContext context, DocumentSnapshot snapshot) {
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
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        snapshot.data['gameNo'],
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
                      Icons.event,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Text(
//                List<String>  trainer= new List<String>.from(snapshot.data['trainer']);
                snapshot.data['day']. toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])
    );
  }

}
