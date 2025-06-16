import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user.dart';
import 'package:quickhire/models/user_details.dart';
import 'package:quickhire/screens/auth/signup.dart';
import 'package:quickhire/services/auth/auth_api_response.dart';
import 'package:quickhire/services/auth/auth_api_service.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';
import 'package:quickhire/widgets/custom_input_box.dart';
import 'package:quickhire/widgets/login_google.dart';

import '../../widgets/TermsConditions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthApiService apiService = AuthApiService();
  final _formKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void login() async {
    if (_formKey.currentState?.validate() ?? false) {
      User user = User(
          username: usernameTextController.text.trim(),
          email: usernameTextController.text.trim(),
          password: passwordTextController.text.trim());
      AuthApiResponse apiResponse = await apiService.login(user);

      if (apiResponse.success) {
        UserDetails userDetails = await UserApiService().fetchUser();
        String userType = userDetails.userType;
        SecureStorageService().writeUserType(userType: userType);
        if (userType == "Employer") {
          Navigator.pushNamedAndRemoveUntil(
              context, '/ehome', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/jhome', (route) => false);
        }
      } else {
        showErrorDialog(
          apiResponse.errorMessage ?? "Failed to login",
        );
      }
    } else {
      debugPrint('no success');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      appBar: myCustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 28.0,
            left: 8.0,
            right: 8.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 28.0,
                  ),
                  child: Text(
                    'Your Username',
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CustomInputBox(
                  hint: 'Enter your username',
                  svgIconPath: 'assets/icons/mail.svg',
                  enabled: true,
                  controller: usernameTextController,
                  isPassword: false,
                  hasFocus: false,
                  errorText: "username can't be empty",
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 28.0,
                  ),
                  child: Text(
                    'Your Password',
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: poppinsSemiBold,
                    ),
                  ),
                ),
                CustomInputBox(
                  hint: 'Enter your password',
                  svgIconPath: 'assets/icons/ceye.svg',
                  enabled: true,
                  controller: passwordTextController,
                  isPassword: true,
                  hasFocus: false,
                  errorText: "password can't be empty",
                ),
                TermsConditions(termsUrl: termsUrl, policyUrl: policyUrl),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: login,
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: whiteText,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 28.0,
                  ),
                  child: Center(
                    child: Text(
                      'Or',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: LoginWithGoogleBox(
                    hint: 'Login using Google',
                    svgIconPath: 'assets/icons/google.svg',
                    enabled: false,
                    controller: TextEditingController(),
                    isPassword: false,
                    hasFocus: false,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 28.0,
                  ),
                  child: Center(
                    child: Text(
                      'Create new account',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 4.0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Sign up',
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
        ),
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Login Failed!",
          message: message,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
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
                'Hello there, sign in to continue',
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
}

