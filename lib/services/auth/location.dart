/// Standalone class to change the user's Location.
///
/// This class is created because the all atributes of the AuthUser class is final
/// However we want to continously update the user's location. Therefore although
/// the AuthUser's Location class object is final, we can still change the user's
/// location.
class Location {
  Location(this.latitude, this.longitude);

  double latitude;
  double longitude;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
