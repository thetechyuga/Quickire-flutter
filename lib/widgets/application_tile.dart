import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user_details.dart';
import 'package:quickhire/utlities.dart';

class ApplicationTile extends StatelessWidget {
  final UserDetails user;
  final VoidCallback navigateToUserScreen;
  final Color btnColor;

  const ApplicationTile({
    super.key,
    required this.user,
    required this.navigateToUserScreen,
    required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
        color: bgColor,
        margin: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              row1(),
              const SizedBox(
                height: 28,
              ),
              row2()
            ],
          ),
        ),
      ),
    );
  }

  Row row2() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/location.svg',
          width: 16,
          height: 19,
          color: secondaryText,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          user.city,
          style: const TextStyle(
            color: secondaryText,
            fontSize: smallFontSize,
            fontWeight: poppinsRegular,
          ),
        ),
        const Spacer(),
        Text(
          formatDate(user.isUpdated),
          style: const TextStyle(
            color: secondaryText,
            fontSize: smallFontSize,
            fontWeight: poppinsRegular,
          ),
        ),
      ],
    );
  }

  Row row1() {
    return Row(
      children: [
        user.userPhoto != ''
            ? Image.network(
                '$BASE_URL${user.userPhoto}',
                width: 28,
                height: 28,
              )
            : SvgPicture.asset(
                'assets/icons/user.svg',
                width: 20,
                height: 20,
              ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.role,
                  style: const TextStyle(
                    fontSize: smallFontSize,
                    color: secondaryText,
                    fontWeight: poppinsRegular,
                  ),
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: primaryText,
                    fontSize: mediumFontSize,
                    fontWeight: poppinsRegular,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                )
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: navigateToUserScreen,
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'View',
            style: TextStyle(
              color: whiteText,
              fontWeight: poppinsRegular,
            ),
          ),
        )
      ],
    );
  }
}
