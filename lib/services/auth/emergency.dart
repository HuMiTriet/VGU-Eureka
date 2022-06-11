/// Standalone class to change the user's Emergency.
class Emergency {
  bool lostAndFound;
  bool accident;
  bool thief;
  bool other;
  bool isPublic;
  bool isFilled;
  String situationDetail;
  String locationDescription;

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
      'Lost and Found': lostAndFound,
      'Accident': accident,
      'Thieves': thief,
      'Other': other,
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
