import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/screens/employer/activity/applications_screen.dart';
import 'package:quickhire/screens/employer/add_edit_job_screen.dart';
import 'package:quickhire/screens/employer/profile/company_profile_screen.dart';
import 'package:quickhire/screens/job_seeker/sucess_screen.dart';
import 'package:quickhire/screens/subscription/subscription_screen.dart';
import 'package:quickhire/services/application/application_api_service.dart';
import 'package:quickhire/services/user/subscription_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  final String btnText;
  final Color btnColor;

  const JobDetailsScreen({
    super.key,
    required this.job,
    required this.btnText,
    required this.btnColor,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  SubscriptionApiService subscriptionApiService = SubscriptionApiService();
  ApplicationApiService applicationApiService = ApplicationApiService();

  onApply(int jobId) async {
    if (widget.btnText == "View Applications") {
      navigateToApplications(jobId);
      return;
    }

    if (widget.btnText != "Apply") {
      showErrorDialog('Application in Progress',
          'Your application is currently being processed. Please wait, and a recruiter will reach out to you soon.');
      return;
    }
    bool isSubscribed = await subscriptionApiService.checkSubscriptionStatus();
    if (!isSubscribed) {
      showErrorDialog('Subscription Required',
          'You need an active subscription to apply for this job. Please subscribe to proceed.');
      return;
    }
    bool isSuccess = await applicationApiService.applyForJob(jobId);
    if (isSuccess) {
      navigateToSucces();
    }
    debugPrint("Applied for the job");
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          message: message,
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscriptionPlanScreen(),
              ),
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  navigateToCompanyDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyProfileScreen(
          companyId: widget.job.company.companyId,
        ),
      ),
    );
  }

  navigateToSucces() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(),
      ),
    );
  }

  navigateToApplications(int jobId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationsScreen(
          jobId: jobId,
        ),
      ),
    );
  }

  navigateToEditJobDetails(Job job) async {
    bool response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditJobScreen(
          job: job,
        ),
      ),
    );
    if (response) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> skills =
        widget.job.skills.split(',').map((skill) => skill.trim()).toList();
    return Scaffold(
      appBar: customAppBar(widget.job.role),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      companyDetails(),
                      tiles(),
                      jobDescriptionHeading('Job Description'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            text: widget.job.jobDesc,
                            style: const TextStyle(
                              fontSize: mediumFontSize,
                              fontWeight: poppinsRegular,
                              color: primaryText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      jobDescriptionHeading('Requried Skills'),
                      const SizedBox(
                        height: 12,
                      ),
                      displaySkills(skills),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: horizontalPadding,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: widget.btnColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                onApply(widget.job.jobId);
              },
              child: Text(
                widget.btnText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: whiteText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displaySkills(List<String> skills) {
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

  Padding jobDescriptionHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.only(
        top: verticalPadding,
        left: verticalPadding,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          heading,
          style: const TextStyle(
            fontSize: largeFontSize,
            fontWeight: poppinsSemiBold,
            color: primaryText,
          ),
        ),
      ),
    );
  }

  Row tiles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        infoTiles("Salary", widget.job.expectedSalary,
            'assets/icons/salary.svg', seekerCircleColor),
        infoTiles("Job Type", widget.job.jobType, 'assets/icons/job.svg',
            employerCircleColor),
      ],
    );
  }

  Widget companyDetails() {
    return GestureDetector(
      onTap: navigateToCompanyDetails,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: secondaryColor,
            backgroundImage:
                NetworkImage(BASE_URL + widget.job.company.companyLogo),
          ),
          const SizedBox(
            height: verticalPadding,
          ),
          Text(
            widget.job.role,
            style: const TextStyle(
              color: primaryText,
              fontWeight: poppinsRegular,
              fontSize: largeFontSize,
            ),
          ),
          Text(
            '${widget.job.company.companyName} - ${widget.job.company.location}',
            style: const TextStyle(
              color: secondaryText,
              fontWeight: poppinsRegular,
              fontSize: smallFontSize,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatDate(widget.job.company.isUpdated),
                style: const TextStyle(
                  color: secondaryText,
                  fontWeight: poppinsRegular,
                  fontSize: smallFontSize,
                ),
              ),
            ),
          ),
        ],
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

  Widget infoTiles(String title, String value, String icon, Color tileColor) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardPadding = 16.0;
    double cardWidth = (screenWidth - 3 * cardPadding) / 2;
    return SizedBox(
      width: cardWidth,
      child: Card(
        color: bgColor,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: tileColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          icon,
                          width: 24,
                          height: 24,
                          color: primaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: primaryText,
                          fontWeight: poppinsRegular,
                          fontSize: smallFontSize,
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                          color: primaryText,
                          fontWeight: poppinsSemiBold,
                          fontSize: smallFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar customAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
      actions: widget.job != null
          ? [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/note.svg',
                  width: 24,
                  height: 24,
                  color: secondaryText,
                ),
                onPressed: () async {
                  navigateToEditJobDetails(widget.job);
                },
              ),
            ]
          : [],
    );
  }
}
