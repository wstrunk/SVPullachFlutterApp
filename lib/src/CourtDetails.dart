import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:svpullach/src/Court.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';


class CourtDetails extends StatefulWidget {
  const CourtDetails ({
    @required this.place,
    Key key,
  })  : assert(place != null),
        super(key: key);

  final Court place;

  @override
  CourtDetailsState createState() => CourtDetailsState();
}

class CourtDetailsState extends State<CourtDetails> {
  Court _place;
  GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _center ;
  static const LatLng _home = const LatLng(48.060286, 11.513958);


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  initState()  {
    _place = widget.place;
    _nameController.text = _place.courtName;
    _descriptionController.text = _place.address;

  _center = _place.latLng;
  //_getCourtLocation();
    // add a marker for the court so the user can navigate to it
    _markers.add(Marker(
      markerId: MarkerId(_center.toString()),
      position:_center,)
    );
    return super.initState();
  }

  Future _onMapCreated(GoogleMapController controller)  {
    _mapController = controller;
    setState(()  {
//      _markers.add(Marker(
        //Todo we should figure out the location before adding a marker
        //markerId: MarkerId(_place.latLng.toString()),
        //position: _place.latLng,
//      ));
    });
  }

  Widget _detailsBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
      children: <Widget>[
        _NameTextField(
          controller: _nameController,
          onChanged: (String value) {
            setState(() {
              _place = _place.copyWith(name: value);
            });
          },
        ),
        _DescriptionTextField(
          controller: _descriptionController,
          onChanged: (String value) {
            setState(() {
              _place = _place.copyWith(address: value);
            });
          },
        ),
        _Map(
          center: _center,// ToDO change to _place.latLng,
          mapController: _mapController,
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_place.courtName}'),
//        backgroundColor: Colors.green[700],
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
            child: IconButton(
              icon: const Icon(Icons.save, size: 30.0),
              onPressed: () {
//                widget.onChanged(_place);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _detailsBody(),
      ),
    );
  }
//ToDo unfortunately it is not called at the right time
  _getCourtLocation() async {
    //we should figure out the location before adding a marker
    var addresses = await Geocoder.local.findAddressesFromQuery(_place.address);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    _center = new LatLng(
        first.coordinates.latitude, first.coordinates.longitude);
    _markers.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center,)
    );
  }

}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(fontSize: 18.0),
        ),
        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
        autocorrect: true,
        controller: controller,
        onChanged: (String value) {
          onChanged(value);
        },
      ),
    );
  }
}

class _DescriptionTextField extends StatelessWidget {
  const _DescriptionTextField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Adresse',
          labelStyle: TextStyle(fontSize: 18.0),
        ),
        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
        maxLines: null,
        autocorrect: true,
        controller: controller,
        onChanged: (String value) {
          onChanged(value);
        },
      ),
    );
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
