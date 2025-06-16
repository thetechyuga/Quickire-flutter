import 'package:flutter/material.dart';
import 'package:quickhire/constants/variables.dart';

class HomepageBanner extends StatelessWidget {
  const HomepageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 0,
        bottom: horizontalPadding,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Image.asset(
          'assets/images/banner.png',
          width: constraints.maxWidth,
          fit: BoxFit.contain,
        );
      }),
    );
  }
}
