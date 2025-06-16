class Subscription {
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Subscription({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  // Factory constructor to create an instance from JSON
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      userId: json['user'] ?? 0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime(1970, 1, 1), // Default date if null
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime(1970, 1, 1), // Default date if null
      isActive: json['is_active'] ?? false,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
    };
  }
}
