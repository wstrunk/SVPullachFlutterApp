import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/Widgets/SvpScaffold.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
//import 'place_detail.dart';

const kGoogleApiKey = "AIzaSyDC29de9wdqNQCx3IWgUy0q9sl9jn9t73w";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);


class LocationPage extends StatefulWidget {

  @override
  _LocationPageState createState() => _LocationPageState();


}

class _LocationPageState extends State<LocationPage> {
  Completer<GoogleMapController> _mapController = Completer();
  static const LatLng _center = const LatLng(48.060286, 11.513958);

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
            .collection("courts")
        .orderBy("courtName")
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
                        snapshot.data['courtName'],
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
                      // call maps
                    },
                    icon: Icon(
                      Icons.map,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Text(
//                List<String>  trainer= new List<String>.from(snapshot.data['trainer']);
                snapshot.data['address'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ])
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }


}
