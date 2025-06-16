class ExperienceJourney {
  int? experienceJourneyId;
  final int? userDetails;
  final String role;
  final String companyName;
  final String department;
  final String industry;
  final String skills;
  final int startYear;
  final int endYear;
  final String experienceType;

  ExperienceJourney({
    this.experienceJourneyId,
    this.userDetails,
    required this.role,
    required this.companyName,
    required this.department,
    required this.industry,
    required this.skills,
    required this.startYear,
    required this.endYear,
    required this.experienceType,
  });

  factory ExperienceJourney.fromJson(Map<String, dynamic> json) {
    return ExperienceJourney(
      experienceJourneyId: json['experience_journey_id'],
      userDetails: json['user_details'],
      role: json['role'],
      companyName: json['company_name'],
      department: json['department'],
      industry: json['industry'],
      skills: json['skills'],
      startYear: json['start_year'],
      endYear: json['end_year'],
      experienceType: json['experience_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_details': userDetails,
      'role': role,
      'company_name': companyName,
      'department': department,
      'industry': industry,
      'skills': skills,
      'start_year': startYear,
      'end_year': endYear,
      'experience_type': experienceType,
    };
  }
}
