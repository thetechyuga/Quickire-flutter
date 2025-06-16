import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/utlities.dart';

class JobTile extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Job job;
  final VoidCallback navigateToJob;

  const JobTile({
    super.key,
    required this.buttonColor,
    required this.buttonText,
    required this.job,
    required this.navigateToJob,
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
          job.company.location,
          style: const TextStyle(
            color: secondaryText,
            fontSize: smallFontSize,
            fontWeight: poppinsRegular,
          ),
        ),
        const Spacer(),
        Text(
          formatDate(job.isUpdated),
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
        job.company.companyLogo != ''
            ? Image.network(
                '$BASE_URL/${job.company.companyLogo}',
                width: 28,
                height: 28,
              )
            : SvgPicture.asset(
                'assets/icons/job.svg',
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
                  job.company.companyName,
                  style: const TextStyle(
                    fontSize: smallFontSize,
                    color: secondaryText,
                    fontWeight: poppinsRegular,
                  ),
                ),
                Text(
                  job.role,
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
          onPressed: navigateToJob,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: whiteText,
              fontWeight: poppinsRegular,
            ),
          ),
        )
      ],
    );
  }
}
