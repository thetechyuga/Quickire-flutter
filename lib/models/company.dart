class Company {
  int companyId;
  String companyName;
  final String companyTitle;
  final String companyDesc;
  final String companyLink;
  final String linkedinLink;
  final String industry;
  final String foundedYear;
  String companyLogo;
  final String companyBackground;
  String location;
  bool isApproved;
  String isCreated;
  String isUpdated;
  int userDetails;

  Company({
    required this.companyId,
    required this.companyName,
    required this.companyTitle,
    required this.companyDesc,
    required this.companyLink,
    required this.linkedinLink,
    required this.industry,
    required this.foundedYear,
    required this.companyLogo,
    required this.companyBackground,
    required this.location,
    required this.isApproved,
    required this.isCreated,
    required this.isUpdated,
    required this.userDetails,
  });

  // Method to deserialize JSON to Company object
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['company_id'],
      companyName: json['company_name'],
      companyTitle: json['company_title'],
      companyDesc: json['company_desc'] ?? '',
      companyLink: json['company_link'] ?? '',
      linkedinLink: json['linkedin_link'] ?? '',
      industry: json['industry'] ?? '',
      foundedYear: json['founded_year'] ?? '',
      companyLogo: json['company_logo'] ?? '',
      companyBackground: json['company_background'] ?? '',
      location: json['location'],
      isApproved: json['is_approved'],
      isCreated: json['is_created'],
      isUpdated: json['is_updated'],
      userDetails: json['user_details'],
    );
  }

  // Method to serialize Company object to JSON
  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'company_name': companyName,
      'company_title': companyTitle,
      'company_desc': companyDesc,
      'company_link': companyLink,
      'linkedin_link': linkedinLink,
      'industry': industry,
      'founded_year': foundedYear,
      'company_logo': companyLogo,
      'company_background': companyBackground,
      'location': location,
      'is_approved': isApproved,
      'is_created': isCreated,
      'is_updated': isUpdated,
      'user_details': userDetails,
    };
  }
}
