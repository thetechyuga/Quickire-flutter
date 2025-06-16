// job_model.dart
import 'package:quickhire/models/company.dart';

class Job {
  final int jobId;
  final String role;
  final Company company;
  final String expectedSalary;
  final String jobType;
  final String jobDesc;
  final String skills;
  final bool isActive;
  final String isCreated;
  final String isUpdated;

  Job({
    required this.jobId,
    required this.role,
    required this.company,
    required this.expectedSalary,
    required this.jobType,
    required this.jobDesc,
    required this.skills,
    required this.isActive,
    required this.isCreated,
    required this.isUpdated,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['job_id'],
      role: json['role'],
      company: Company.fromJson(json['company']),
      expectedSalary: json['expected_salary'],
      jobType: json['job_type'],
      jobDesc: json['job_desc'],
      skills: json['skills'],
      isActive: json['is_active'],
      isCreated: json['is_created'],
      isUpdated: json['is_updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'role': role,
      'company': company.toJson(),
      'expected_salary': expectedSalary,
      'job_type': jobType,
      'job_desc': jobDesc,
      'skills': skills,
      'is_active': isActive,
      'is_created': isCreated,
      'is_updated': isUpdated,
    };
  }
}
