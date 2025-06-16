import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickhire/constants/colors.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Lottie Animation
            Lottie.asset(
                'assets/anim/sucess.json', // Replace with your Lottie file path
                width: 200,
                height: 200,
                fit: BoxFit.fill),

            const SizedBox(
              height: 40,
            ),

            const Text(
              'Application Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const Text(
              'Your application has been successfully submitted. The recruiters will get in touch with you soon.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
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
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/jhome',
                    arguments: 1,
                  );
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
}
