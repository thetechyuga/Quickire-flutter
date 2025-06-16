import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/utlities.dart';

class SubscriptionDetailsCard extends StatelessWidget {
  final bool isActive;
  final VoidCallback navigateToSubscriptionPlansScreen;
  final DateTime parsedStartDate, parsedEndDate;
  const SubscriptionDetailsCard({
    super.key,
    required this.isActive,
    required this.navigateToSubscriptionPlansScreen,
    required this.parsedStartDate,
    required this.parsedEndDate,
  });

  @override
  Widget build(BuildContext context) {
    bool noUser = parsedStartDate == DateTime(1970, 1, 1) ? true : false;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Subscription Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: poppinsSemiBold,
                  ),
                ),
                const Spacer(),
                !isActive
                    ? GestureDetector(
                        onTap: navigateToSubscriptionPlansScreen,
                        child: const Text(
                          'Upgrade',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: smallFontSize,
                            fontWeight: poppinsRegular,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: const Text('Start Date'),
              subtitle: Text(
                noUser ? ' - ' : formatSubDate(parsedStartDate),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: const Text('End Date'),
              subtitle: Text(
                noUser ? ' - ' : formatSubDate(parsedEndDate),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                isActive
                    ? 'assets/icons/check_circle.svg'
                    : 'assets/icons/cross_circle.svg',
                color: isActive ? Colors.green : Colors.red,
                width: 24,
                height: 24,
              ),
              title: const Text('Status'),
              subtitle: Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
