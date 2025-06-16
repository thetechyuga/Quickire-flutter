import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user_details.dart';

class ProfileBanner extends StatelessWidget {
  final UserDetails user;
  const ProfileBanner({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      child: Card(
        color: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            left: 24,
            bottom: 24,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(BASE_URL + user.userPhoto),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: largeFontSize,
                        fontWeight: poppinsSemiBold,
                        color: primaryText,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/job.svg',
                          width: 12,
                          height: 12,
                          color: secondaryText,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          user.role,
                          style: const TextStyle(
                            fontSize: smallFontSize,
                            fontWeight: poppinsRegular,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location.svg',
                          width: 12,
                          height: 12,
                          color: secondaryText,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          user.city,
                          style: const TextStyle(
                            fontSize: smallFontSize,
                            fontWeight: poppinsRegular,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
