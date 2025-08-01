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
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool enableOTP = false;
  String getOtpFromFields() => _controllers.map((c) => c.text).join();

  void sendOTP() async {
    if (_formKey.currentState?.validate() ?? false) {
      User user = User(
          username: usernameTextController.text.trim(),
          email: usernameTextController.text.trim(),
          password: '');
      AuthApiResponse apiResponse = await apiService.sendOTP(user.email);

      if (apiResponse.success) {
        setState(() {
          enableOTP = true;
        });
      } else {
        setState(() {
          enableOTP = false;
        });
        showErrorDialog(
          apiResponse.errorMessage ?? "Failed to login",
        );
      }
    } else {
      debugPrint('no success');
    }
  }

  void login() async {
    if (_formKey.currentState?.validate() ?? false) {
      User user = User(
          username: usernameTextController.text.trim(),
          email: usernameTextController.text.trim(),
          password: getOtpFromFields());
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
                  // child: Text(
                  //   'Your Username',
                  //   style: TextStyle(
                  //     color: primaryText,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  child: Text(
                    'Your Email',
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                CustomInputBox(
                  hint: 'Enter your Email',
                  svgIconPath: 'assets/icons/mail.svg',
                  enabled: true,
                  controller: usernameTextController,
                  isPassword: false,
                  hasFocus: false,
                  errorText: "username can't be empty",
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 28.0,
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
                      child: !enableOTP
                          ? const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: whiteText,
                              ),
                            )
                          : const Text(''),
                    )),

                enableOTP
                    ? const Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 28.0,
                        ),
                        // child: Text(
                        //   'Your Password',
                        //   style: TextStyle(
                        //     color: primaryText,
                        //     fontWeight: poppinsSemiBold,
                        //   ),
                        // ),
                        child: Text(
                          'Enter OTP',
                          style: TextStyle(
                            color: primaryText,
                            fontWeight: poppinsSemiBold,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 5,
                      ),
                // CustomInputBox(
                //   hint: 'Enter your password',
                //   svgIconPath: 'assets/icons/ceye.svg',
                //   enabled: true,
                //   controller: passwordTextController,
                //   isPassword: true,
                //   hasFocus: false,
                //   errorText: "password can't be empty",
                // ),
                const SizedBox(
                  height: 15,
                ),
                enableOTP
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 44,
                            height: 55,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              maxLength: 1,
                              onChanged: (val) {
                                if (val.length == 1 && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (val.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                          );
                        }),
                      )
                    : const SizedBox(
                        width: 5,
                      ),
                enableOTP
                    ? Padding(
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
                      )
                    : const SizedBox(
                        width: 5,
                      ),
                TermsConditions(termsUrl: termsUrl, policyUrl: policyUrl),

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
