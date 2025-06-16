import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/utlities.dart';

class UserRoleSelectionScreen extends StatefulWidget {
  const UserRoleSelectionScreen({super.key});

  @override
  State<UserRoleSelectionScreen> createState() =>
      _UserRoleSelectionScreenState();
}

class _UserRoleSelectionScreenState extends State<UserRoleSelectionScreen> {
  final UserApiService userApiService = UserApiService();
  String _selectedRole = '';

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleDiameter = screenWidth * 0.4;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: myCustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 28.0,
          left: 8.0,
          right: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleCircle('Employer', circleDiameter,
                        'assets/icons/employer.svg', employerCircleColor),
                    const SizedBox(
                      height: verticalPadding,
                    ),
                    Text(
                      'Employer',
                      style: TextStyle(
                        color: _selectedRole == 'Employer'
                            ? primaryColor
                            : primaryText,
                        fontWeight: poppinsSemiBold,
                        fontSize: mediumFontSize,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleCircle('Job Seeker', circleDiameter,
                        'assets/icons/jobseeker.svg', seekerCircleColor),
                    const SizedBox(
                      height: verticalPadding,
                    ),
                    Text(
                      'Job Seeker',
                      style: TextStyle(
                        color: _selectedRole == 'Job Seeker'
                            ? primaryColor
                            : primaryText,
                        fontWeight: poppinsSemiBold,
                        fontSize: mediumFontSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 4.0,
                bottom: verticalPadding,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'user_type': _selectedRole,
                  };
                  final response = await userApiService.patchUser(data);
                  if (response.success) {
                    SecureStorageService().writeUserType(
                        userType: response.userDetails?.userType);
                    if (response.userDetails?.userType == "Employer") {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/createCompany', (route) => false);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/jhome', (route) => false);
                    }
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: whiteText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize myCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120.0),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 64,
          bottom: 0,
          left: 8,
        ),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 28,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Hello there, choose to continue',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCircle(
      String role, double diameter, String assetUri, Color bgColor) {
    return GestureDetector(
      onTap: () => _onRoleSelected(role),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: Border.all(
            color: _selectedRole == role ? primaryColor : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetUri,
              width: diameter / 2,
              height: diameter / 3,
              color: primaryText,
            ),
          ],
        ),
      ),
    );
  }
}
