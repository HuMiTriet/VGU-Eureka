import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routing_client_dart/routing_client_dart.dart';

class Routing {
  static final manager = OSRMManager();
  static final routing = Routing._();
  static late LatLng location;

  static Routing getInstance() {
    return routing;
  }

  Routing._();

  Future<List<LatLng>> getPointsFromUser(LatLng to) async {
    return _getPoints(location, to);
  }

  Future<List<LatLng>> _getPoints(LatLng from, LatLng to) async {
    var road = await manager.getRoad(
      waypoints: [
        LngLat(lat: from.latitude, lng: from.longitude),
        LngLat(lat: to.latitude, lng: to.longitude)
      ],
      geometrie: Geometries.geojson,
      steps: true,
      languageCode: 'en',
    );
    log('polyline: ${road.polyline!}', name: 'Routing: getPoints');
    return _toLatLngList(road.polyline!);
  }

  List<LatLng> _decodeEncodedPolyline(String encoded) {
    var poly = <LatLng>[];
    var index = 0, len = encoded.length;
    var lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      var dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      var dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      var p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  List<LatLng> _toLatLngList(List<LngLat> lngLatList) {
    var latLngList = <LatLng>[];
    latLngList.clear();
    for (var element in lngLatList) {
      latLngList.add(LatLng(element.lat, element.lng));
    }
    return latLngList;
  }
}
