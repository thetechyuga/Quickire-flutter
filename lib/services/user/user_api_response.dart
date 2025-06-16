import 'package:quickhire/models/user_details.dart';

class UserApiResponse {
  final bool success;
  final UserDetails? userDetails;

  UserApiResponse({required this.success, this.userDetails});
}
