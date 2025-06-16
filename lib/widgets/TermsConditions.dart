import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../constants/variables.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({
    super.key,
    required this.termsUrl,
    required this.policyUrl,
  });

  final Uri termsUrl;
  final Uri policyUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 28,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By logging in, you agree to our ',
          style: const TextStyle(
              color: secondaryText,
              fontSize: 14,
              fontWeight: poppinsRegular), // Regular text style
          children: <TextSpan>[
            TextSpan(
              text: 'Terms and Conditions',
              style: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  fontWeight: poppinsRegular),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  // Handle Terms and Conditions tap
                  !await launchUrl(
                    termsUrl,
                  );
                },
            ),
            const TextSpan(
              text: ' and acknowledge that you have read our ',
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  fontWeight: poppinsRegular),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  !await launchUrl(
                    policyUrl,
                  );
                },
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}