/// Standalone class to change the user's Location.
///
/// This class is created because the all atributes of the AuthUser class is final
/// However we want to continously update the user's location. Therefore although
/// the AuthUser's Location class object is final, we can still change the user's
/// location.
class Location {
  double latitude;
  double longitude;

  Location({this.latitude = 0.0, this.longitude = 0.0});

  Map<String, double> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
