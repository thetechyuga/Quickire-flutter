import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/utlities.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final SecureStorageService secureStorageService = SecureStorageService();
  final UserApiService userApiService = UserApiService();
  late Future<bool> _isNetworkPresent = userApiService.isNetworkConnected();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNetworkAndNavigate();
    });
  }

  Future<void> _checkNetworkAndNavigate() async {
    try {
      bool isNetworkPresent = await userApiService.isNetworkConnected();
      if (isNetworkPresent) {
        FlutterNativeSplash.remove();
        _checkAuth();
      } else {
        FlutterNativeSplash.remove();
        networkErrorWidget('No network connection',
            'Please check your internet connection and retry');
      }
    } catch (e) {
      FlutterNativeSplash.remove();
      networkErrorWidget('No network connection',
          'Please check your internet connection and retry');
    }
  }

  _checkAuth() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        String? token = await secureStorageService.readToken();
        String? userType = await secureStorageService.readUserType();

        if (!mounted) return;

        if (token != null) {
          if (userType != null && userType == "Employer") {
            Navigator.pushReplacementNamed(context, '/ehome');
          } else {
            Navigator.pushReplacementNamed(context, '/jhome');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (error) {
        print("Error checking auth: $error");
        await secureStorageService.clear();
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  onRetry() {
    setState(() {
      _isNetworkPresent = userApiService.isNetworkConnected();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isNetworkPresent,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return networkErrorWidget('No network connection',
              'Please check your internet connection and retry');
        } else {
          _checkAuth();
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Scaffold networkErrorWidget(String title, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/logo/appicon.png',
              width: 84,
              height: 84,
            ),
            Column(
              children: [
                Lottie.asset(
                  'assets/anim/network_error.json',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: poppinsSemiBold,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: smallFontSize,
                    color: secondaryText,
                    fontWeight: poppinsRegular,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // minimumSize: const Size(double.infinity, 44),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onRetry,
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: whiteText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
