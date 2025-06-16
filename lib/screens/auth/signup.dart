import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user.dart';
import 'package:quickhire/screens/auth/login.dart';
import 'package:quickhire/screens/auth/user_role_selection_screen.dart';
import 'package:quickhire/services/auth/auth_api_response.dart';
import 'package:quickhire/services/auth/auth_api_service.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';
import 'package:quickhire/widgets/custom_input_box.dart';
import 'package:quickhire/widgets/login_google.dart';

import '../../widgets/TermsConditions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthApiService apiService = AuthApiService();
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (confirmPasswordTextController.text != passwordTextController.text) {
        print("Password Mistmatch");
        return;
      }
      User user = User(
          username: usernameTextController.text.trim(),
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());
      AuthApiResponse apiResponse = await apiService.signup(user);
      if (apiResponse.success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserRoleSelectionScreen()),
        );
      } else {
        showErrorDialog(
          apiResponse.errorMessage ?? "Failed to signup",
        );
      }
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
              children: [
                textFields(
                  title: 'Your Username',
                  hint: 'Enter your username',
                  svgIconPath: 'assets/icons/profile.svg',
                  enabled: true,
                  controller: usernameTextController,
                  isPassword: false,
                  hasFocus: false,
                  errorText: "username can't be empty",
                ),
                textFields(
                  title: 'Your Email',
                  hint: 'Enter your email',
                  svgIconPath: 'assets/icons/mail.svg',
                  enabled: true,
                  controller: emailTextController,
                  isPassword: false,
                  hasFocus: false,
                  errorText: "email can't be empty",
                ),
                textFields(
                  title: 'Your Password',
                  hint: 'Enter your password',
                  svgIconPath: 'assets/icons/ceye.svg',
                  enabled: true,
                  controller: passwordTextController,
                  isPassword: true,
                  hasFocus: false,
                  errorText: "password can't be empty",
                ),
                textFields(
                  title: 'Confirm Password',
                  hint: 'ReEnter your password',
                  svgIconPath: 'assets/icons/ceye.svg',
                  enabled: true,
                  controller: confirmPasswordTextController,
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
                    onPressed: signup,
                    child: const Text(
                      'Sign Up',
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
                      'Already have an account?',
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log In',
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

  Column textFields(
      {title,
      hint,
      svgIconPath,
      enabled,
      controller,
      isPassword,
      hasFocus,
      errorText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 28.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomInputBox(
          hint: hint,
          svgIconPath: svgIconPath,
          enabled: enabled,
          controller: controller,
          isPassword: isPassword,
          hasFocus: hasFocus,
          errorText: errorText,
        ),
      ],
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Signup Failed!",
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
