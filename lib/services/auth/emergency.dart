/// Standalone class to change the user's Emergency.
class Emergency {
  late bool lostAndFound;
  late bool accident;
  late bool thief;
  late bool other;
  late bool isPublic;
  late bool isFilled;
  late String situationDetail;
  late String locationDescription;

  Emergency({
    this.lostAndFound = false,
    this.accident = false,
    this.thief = false,
    this.other = false,
    this.isPublic = false,
    this.isFilled = false,
    this.situationDetail = '',
    this.locationDescription = '',
  });

  Emergency.fromJson(Map<String, dynamic> json) {
    lostAndFound = json['lostAndFound'];
    accident = json['accident'];
    thief = json['thief'];
    other = json['other'];
    isPublic = json['isPublic'];
    isFilled = json['isFilled'];
    situationDetail = json['situationDetail'];
    locationDescription = json['locationDescription'];
  }

  void updateEmergency({
    required String situationDetail,
    required String locationDescription,
    required bool isPublic,
  }) {
    this.situationDetail = situationDetail;
    this.locationDescription = locationDescription;
    this.isPublic = isPublic;
    isFilled = true;
  }

  void clearEmergency() {
    lostAndFound = false;
    accident = false;
    thief = false;
    other = false;
    isPublic = false;
    isFilled = false;
    situationDetail = '';
    locationDescription = '';
  }

  Map<String, dynamic> toJson() {
    return {
      'lostAndFound': lostAndFound,
      'accident': accident,
      'thief': thief,
      'other': other,
      'situationDetail': situationDetail,
      'locationDescription': locationDescription,
    };
  }

  @override
  String toString() {
    return '''Emergency{
      lostAndFound: $lostAndFound, 
      accident: $accident, 
      thief: $thief, 
      other: $other, 
      isPublic: $isPublic, 
      isFilled: $isFilled, 
      situationDetail: $situationDetail, 
      locationDescription: $locationDescription
      }''';
  }
}
