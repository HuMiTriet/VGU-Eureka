import 'package:etoet/services/map/geoflutterfire/geoflutterfire.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

void main() {
  test('test geoflutterfire', () {
    var geoFirePoint = GeoFirePoint(10, 10);
    var hash = geoFirePoint.hash;
    var geoPoint = geoFirePoint.geoPoint;
    expect('s1z0gs3y0', hash);
    expect(10, geoPoint.latitude);
    expect(10, geoPoint.longitude);
  });
}
