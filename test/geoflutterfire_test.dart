import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test geoflutterfire', () {
    var geoFirePoint = GeoFlutterFire.getGeoFirePoint(10, 10);
    var hash = geoFirePoint.hash;
    var geoPoint = geoFirePoint.geoPoint;
    expect('s1z0gs3y0', hash);
    expect(10, geoPoint.latitude);
    expect(10, geoPoint.longitude);

    GeoFlutterFire.updateEmergencySignalLocation(
        uid: '3pPvlaWnSCT1zvnT14R059JAdSp2', lat: 10, lng: 10);
  });
}
