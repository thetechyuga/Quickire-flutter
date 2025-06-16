class EducationJourney {
  int? educationJourneyId;
  final int userDetails;
  final String course;
  final String instituteName;
  final int startYear;
  final int endYear;
  final String courseType;

  EducationJourney({
    this.educationJourneyId,
    required this.userDetails,
    required this.course,
    required this.instituteName,
    required this.startYear,
    required this.endYear,
    required this.courseType,
  });

  factory EducationJourney.fromJson(Map<String, dynamic> json) {
    return EducationJourney(
      educationJourneyId: json['education_journey_id'],
      userDetails: json['user_details'],
      course: json['course'],
      instituteName: json['institute_name'],
      startYear: json['start_year'],
      endYear: json['end_year'],
      courseType: json['course_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_details': userDetails,
      'course': course,
      'institute_name': instituteName,
      'start_year': startYear,
      'end_year': endYear,
      'course_type': courseType,
    };
  }
}
