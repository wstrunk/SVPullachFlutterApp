import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/Widgets/SvpScaffold.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/services.dart';

class GameEventPage extends StatefulWidget {

  @override
  _GameEventPageState createState() => _GameEventPageState();


}

class _GameEventPageState extends State<GameEventPage> {

  _GameEventPageState() {
  }

  @override
  initState() {
    super.initState();
  }

//Todo set the parameters according to the document received
  void _createCalendarEvent(DocumentSnapshot snapshot) async {
    var homeTeam = snapshot.data['homeTeam'];
    var guestTeam = snapshot.data['guestTeam'];
    var league = snapshot.data['league'];
    var startDate = snapshot.data['day'];
    var startTimeString = snapshot.data['time'];
    var startTime = _parse(startDate + " " + startTimeString);

    final Event event = Event(
      title: league + ": " + homeTeam + " - " + guestTeam,
      description: 'Event description',
      location: snapshot.data['court'],
      startDate: startTime,
      endDate: startTime.add(Duration(hours: 1)),
      allDay: false,
    );
    Add2Calendar.addEvent2Cal(event);
  }

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
    if (dayString.length < 2) {
      dayString = "0" + dayString;
    }
    var monthString = now.month.toString();
    if (monthString.length < 2) {
      monthString = "0" + monthString;
    }
    var nowString = dayString + "." + monthString + "." + now.year.toString();
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("game_events")
//            .where("day", isGreaterThanOrEqualTo: nowString)
        .orderBy("day")
        .orderBy("league")
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
                        snapshot.data['gameNo'] + " " +snapshot.data['league'],
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
                      _createCalendarEvent(snapshot);
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
                snapshot.data['day'].toString() + " " + snapshot.data['time'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])
    );
  }


  static final RegExp _parseFormat = new RegExp(
      r'^(([0-2][0-9]|(3)[0-1]))\.(((0)[0-9])|((1)[0-2]))(\.)(\d{4})' // Day part.
      r' ([0-2][0-9]):([0-5][0-9])$');


  static DateTime _parse(String formattedString) {
    var re = _parseFormat;
    Match match = re.firstMatch(formattedString);
    if (match != null) {
      int parseIntOrZero(String matched) {
        if (matched == null) return 0;
        return int.parse(matched);
      }

      int day = parseIntOrZero(match[1]);
      int month = parseIntOrZero(match[4]);
      int years = parseIntOrZero(match[10]);
      int hour = parseIntOrZero(match[11]);
      int minute = parseIntOrZero(match[12]);
      return new DateTime(years, month, day, hour, minute);
    } else {
      throw new FormatException("Invalid date format", formattedString);
    }
  }
}