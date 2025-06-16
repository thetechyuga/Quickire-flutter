class UserDetails {
  final int userId;
  final String name;
  final String userPhoto;
  final String email;
  final String role;
  final String city;
  final String skills;
  final String userType;
  final String languages;
  final String isCreated;
  final String isUpdated;

  UserDetails({
    required this.userId,
    required this.name,
    required this.userPhoto,
    required this.email,
    required this.role,
    required this.city,
    required this.skills,
    required this.userType,
    required this.languages,
    required this.isCreated,
    required this.isUpdated,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['user_id'], // Provide default value for int
      name: json['name'], // Provide default value for String
      userPhoto: json['user_photo'] ?? "",
      email: json['email'],
      role: json['role'] ?? 'Unkown',
      city: json['city'] ?? 'Unkown',
      skills: json['skills'] ?? 'Not yet added',
      userType: json['user_type'],
      languages: json['languages'] ?? 'Not yet added',
      isCreated: json['is_created'],
      isUpdated: json['is_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'role': role,
      'city': city,
      'skills': skills,
      'user_type': userType,
      'languages': languages,
      'is_created': isCreated,
      'is_updated': isUpdated,
      'user_photo': userPhoto,
    };
  }
}
