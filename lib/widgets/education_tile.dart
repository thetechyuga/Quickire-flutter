import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/custom_painter/dashed_line_painter.dart';
import 'package:quickhire/models/education_journey.dart';

class EducationTile extends StatelessWidget {
  final EducationJourney educationJourney;
  final VoidCallback onEdit;

  const EducationTile(
      {super.key, required this.educationJourney, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Card(
        elevation: 0,
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: notActive,
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              collegeLogo(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            educationJourney.course,
                            style: const TextStyle(
                              color: primaryText,
                              fontWeight: poppinsRegular,
                              fontSize: smallFontSize,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: onEdit,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  width: 12,
                                  height: 12,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: smallFontSize,
                                    fontWeight: poppinsRegular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        educationJourney.instituteName,
                        style: const TextStyle(
                          fontSize: smallFontSize,
                          fontWeight: poppinsSemiBold,
                          color: secondaryText,
                        ),
                      ),
                      Row(
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Batch ${educationJourney.startYear} - ${educationJourney.endYear}',
                                style: const TextStyle(
                                  fontWeight: poppinsRegular,
                                  fontSize: smallFontSize,
                                  color: secondaryText,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                educationJourney.courseType,
                                style: const TextStyle(
                                  fontWeight: poppinsRegular,
                                  fontSize: smallFontSize,
                                  color: secondaryText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding collegeLogo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/education.svg',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 2,
            height: 20,
            child: CustomPaint(
              painter: DashedLinePainter(strokeColor: notActive),
            ),
          ),
        ],
      ),
    );
  }

  Column subHeading(String label, String response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: smallFontSize,
            fontWeight: poppinsRegular,
            color: secondaryText,
          ),
        ),
        Text(
          response,
          style: const TextStyle(
            fontSize: smallFontSize,
            fontWeight: poppinsRegular,
            color: primaryText,
          ),
        ),
      ],
    );
  }
}
