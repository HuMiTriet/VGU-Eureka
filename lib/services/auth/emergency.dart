/// Standalone class to change the user's Emergency.
class Emergency {
  late bool isPublic;
  late String emergencyType;
  late String situationDetail;
  late String locationDescription;

  Emergency({
    this.isPublic = false,
    this.emergencyType = '',
    this.situationDetail = '',
    this.locationDescription = '',
  });

  Emergency.fromJson(Map<String, dynamic> json) {
    isPublic = json['isPublic'];
    emergencyType = json['emergencyType'];
    situationDetail = json['situationDetail'];
    locationDescription = json['locationDescription'];
  }

  void updateEmergency({
    required String emergencyType,
    required String situationDetail,
    required String locationDescription,
    required bool isPublic,
  }) {
    this.emergencyType = emergencyType;
    this.situationDetail = situationDetail;
    this.locationDescription = locationDescription;
    this.isPublic = isPublic;
  }

  void clearEmergency() {
    isPublic = false;
    emergencyType = '';
    situationDetail = '';
    locationDescription = '';
  }

  Map<String, dynamic> toJson() {
    return {
      'isPublic': isPublic,
      'emergencyType': emergencyType,
      'situationDetail': situationDetail,
      'locationDescription': locationDescription,
    };
  }

  @override
  String toString() {
    return '''Emergency{
      isPublic: $isPublic, 
      emergencyType: $emergencyType,
      situationDetail: $situationDetail, 
      locationDescription: $locationDescription
      }''';
  }
}
