import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Court {
  const Court({@required this.courtNo,
    this.latLng,
    @required this.courtName,
    @required this.address,
    @required this.courtUrl})
      : assert(courtNo != null),
        assert(address != null),
        assert(courtName != null),
        assert(courtUrl != null);

  final String courtNo;
  final LatLng latLng;
  final String courtName;
  final String address;
  final String courtUrl;

  double get latitude => latLng.latitude;

  double get longitude => latLng.longitude;

  Court copyWith(
      {String id, LatLng latLng, String name, String address, String}) {
    return Court(
      courtNo: id ?? this.courtNo,
      latLng: latLng ?? this.latLng,
      courtName: courtName ?? this.courtName,
      address: address ?? this.address,
      courtUrl: courtUrl ?? this.courtUrl,
    );
  }
}
