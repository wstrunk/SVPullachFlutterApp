import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/Widgets/SvpDrawer.dart';
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
/*
      appBar: AppBar(
        title: Text('Mannschaften'),
        actions: <Widget>[
        ],
      ),
*/
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
                        snapshot.data['name'],
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
                      snapshot.reference.updateData({"isDone": true});
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Text(
//                List<String>  trainer= new List<String>.from(snapshot.data['trainer']);
                snapshot.data['trainer']. toString(),
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
