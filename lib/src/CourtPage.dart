import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:svpullach/src/Court.dart';
import 'package:svpullach/src/CourtDetails.dart';
import 'package:svpullach/src/Widgets/SvpScaffold.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
//import 'place_detail.dart';

const kGoogleApiKey = "AIzaSyDC29de9wdqNQCx3IWgUy0q9sl9jn9t73w";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CourtPage extends StatefulWidget {
  @override
  _CourtPageState createState() => _CourtPageState();
}

class _CourtPageState extends State<CourtPage> {
  Completer<GoogleMapController> _mapController = Completer();
  static const LatLng _center = const LatLng(48.060286, 11.513958);
  List<Court> _places = new List();
  TextEditingController editingController = TextEditingController();
  List<String> startFilter = new List();
  List<String> endFilter = new List();

  String filterString = "";
  
  @override
  Widget build(BuildContext context) {
    return SvpScaffold(
      body: Column(
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                   filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Suche",
                    hintText: "Suche Hallenname",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
			_buildContent(context,filterString),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, [String filterString]) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("courts")
            .orderBy("courtName")
//            .where("courtName",  isLessThanOrEqualTo:  filterString + "\uf8ff")
//               .startAt(startFilter).endAt(endFilter)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          _buildLocations(snapshot.data.documents);
          return ListView(
            padding: EdgeInsets.all(16),
            children:
                _places.map((court) => _buildCard(context, court)).toList(),
          );
        },
      ),
    );
  }
  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    if((query.isNotEmpty) && (query.length >=4)) {
      // reload from firebase with where set
      filterString = query;
      startFilter.clear();
      startFilter.add(filterString);
      endFilter.clear();
      endFilter.add(filterString + "\uf8ff");
     _buildContent( context, query);
      return;
    } else {
      return;
	  }
  }
	

  Widget _buildCard(BuildContext context, Court court) {
    return Card(
        elevation: 2.0,
        margin: EdgeInsets.only(bottom: 16),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    court.courtName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: ()
                    // call maps
                    =>
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CourtDetails(
                          place: court,
                        );
                      },
                    )),
                icon: Icon(
                  Icons.map,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Divider(
            height: 1.0,
            color: Colors.grey[700],
          ),
          Text(
            court.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
/*              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),*/
        ]));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  _buildLocations(List<DocumentSnapshot> snapshots) {
    Court newCourt = null;
    LatLng newLatLng = null;

    if (snapshots != null) {
      for (DocumentSnapshot snap in snapshots) {
        if (snap.data['courtName'].toString().startsWith(filterString)){
        if (snap.data['latitude'] != null){
          newLatLng =  new LatLng(
            double.parse(snap.data['latitude'].toString()),
            double.parse(snap.data['longitude'].toString()
            ),
          );
        }
        newCourt = new Court(
            courtNo: snap.data['courtNo'],
            latLng : newLatLng,
            courtName: snap.data['courtName'],
            address: snap.data['address'],
            courtUrl: snap.data['courtUrl']);
        _places.add(newCourt);
      }
        }
    }
  }
}

class _Map extends StatelessWidget {
  const _Map({
    @required this.center,
    @required this.mapController,
    @required this.onMapCreated,
    @required this.markers,
    Key key,
  })  : assert(center != null),
        assert(onMapCreated != null),
        super(key: key);

  final LatLng center;
  final GoogleMapController mapController;
  final ArgumentCallback<GoogleMapController> onMapCreated;
  final Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      elevation: 4.0,
      child: SizedBox(
        width: 340.0,
        height: 240.0,
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 16.0,
          ),
          markers: markers,
          zoomGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: false,
        ),
      ),
    );
  }
  
}
