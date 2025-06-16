import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';

class SkillTile extends StatelessWidget {
  final String headingText;
  final List<String> skills;
  final VoidCallback onEdit;
  const SkillTile({
    super.key,
    required this.skills,
    required this.headingText,
    required this.onEdit,
  });

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
            width: 0.5,
            color: notActive,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    headingText,
                    style: const TextStyle(
                      color: primaryText,
                      fontWeight: poppinsRegular,
                      fontSize: mediumFontSize,
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
              SkillList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget SkillList() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: skills
            .map((skill) => skillPill(
                  skill,
                ))
            .toList(),
      ),
    );
  }

  Card skillPill(String skillName) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          skillName,
          style: const TextStyle(
            fontWeight: poppinsRegular,
            fontSize: smallFontSize,
            color: secondaryText,
          ),
        ),
      ),
    );
  }
}
