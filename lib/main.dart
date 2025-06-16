import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quickhire/screens/auth/login.dart';
import 'package:quickhire/screens/auth/signup.dart';
import 'package:quickhire/screens/auth/splash_screen.dart';
import 'package:quickhire/screens/employer/base_screen.dart';
import 'package:quickhire/screens/employer/create_company.dart';
import 'package:quickhire/screens/job_seeker/base_screen.dart';
import 'constants/colors.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Hire',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: bgColor,
        ),
        scaffoldBackgroundColor: bgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/jhome': (context) => const JBaseScreen(),
        '/ehome': (context) => const EBaseScreen(),
        '/createCompany': (context) => const CreateCompanyProfileScreen(),
      },
      home: const FirstScreen(),
    );
  }
}
