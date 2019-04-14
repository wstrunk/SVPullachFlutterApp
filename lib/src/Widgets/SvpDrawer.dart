import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/LocationPage.dart';
import 'package:flutter_app/src/TeamPage.dart';

class SvpDrawer extends StatelessWidget {
  const SvpDrawer({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('SV Pullach App'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('nächste Spiele'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Spielberichte'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Mannschaften'),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeamPage()),
              );
              // ...
            },
          ),
          new Divider(),
          ListTile(
            title: Text('Hallen'),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationPage()),
              );
              // ...
            },
          ),          ListTile(
            title: Text('Einstellungen'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}