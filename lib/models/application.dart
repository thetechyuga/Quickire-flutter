import 'package:quickhire/models/job.dart';
import 'package:quickhire/models/user_details.dart';

class Application {
  final int applicationId;
  final UserDetails userId;
  final Job job;
  final String status;
  final String isCreated;
  final String isUpdated;

  Application({
    required this.applicationId,
    required this.userId,
    required this.job,
    required this.status,
    required this.isCreated,
    required this.isUpdated,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['application_id'],
      userId: UserDetails.fromJson(json['user_id']),
      job: Job.fromJson(json['job']),
      status: json['status'],
      isCreated: json['is_created'],
      isUpdated: json['is_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'user_id': userId.toJson(),
      'job': job.toJson(),
      'status': status,
      'is_created': isCreated,
      'is_updated': isUpdated,
    };
  }
}
