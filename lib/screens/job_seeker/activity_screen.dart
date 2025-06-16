import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/application.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/screens/job_seeker/job_details_screen.dart';
import 'package:quickhire/services/application/application_api_service.dart';
import 'package:quickhire/widgets/homepage_banner.dart';
import 'package:quickhire/widgets/job_tile.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ApplicationApiService applicationApiService = ApplicationApiService();

  late Future<List<Application>> _applicationFuture;

  final List<String> options = [
    'All Status',
    'Applied',
    'Reviewed',
    'Interview',
    'Selected',
    'Rejected',
  ];

  fetchInitData() {
    _applicationFuture = applicationApiService.fetchApplications();
  }

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }

  getBtnColor(application) {
    if (application.status == "Applied") return appliedButtonColor;
    if (application.status == "Reviewed") return reviewButtonColor;
    if (application.status == "Interview") return interviewButtonColor;
    if (application.status == "Selected") return selectedButtonColor;
    if (application.status == "Rejected") return rejectedButtonColor;
  }

  onOptionClick(String status) async {
    List<Application> updatedApplications;

    if (status == "All Status") {
      updatedApplications = await applicationApiService.fetchApplications();
    } else {
      updatedApplications =
          await applicationApiService.fetchApplicationsBySatus(status);
    }
    setState(() {
      _applicationFuture = Future.value(updatedApplications);
    });
  }

  navigateToJob(Job job, Color color, String text) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          job: job,
          btnColor: color,
          btnText: text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const HomepageBanner(),
                  tabBarOptions(),
                  Center(
                    child: FutureBuilder<List<dynamic>>(
                      future: _applicationFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text(''));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No user data available.'));
                        } else {
                          List<Application> applications =
                              snapshot.data! as List<Application>;

                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final application = applications[index];
                              Color btnColor = getBtnColor(application);
                              return JobTile(
                                navigateToJob: () => navigateToJob(
                                  application.job,
                                  btnColor,
                                  application.status,
                                ),
                                buttonColor: btnColor,
                                buttonText: application.status,
                                job: application.job,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DefaultTabController tabBarOptions() {
    return DefaultTabController(
      length: 6,
      child: TabBar(
        isScrollable: true,
        splashFactory: NoSplash.splashFactory,
        physics: const BouncingScrollPhysics(),
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: primaryColor,
          border: Border.all(
            color: notActive,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: whiteText,
        unselectedLabelColor: notActive,
        labelPadding: const EdgeInsets.all(0),
        onTap: (index) async {
          onOptionClick(options[index]);
        },
        tabs: [
          Tab(
            child: statusButton("All Status"),
          ),
          Tab(child: statusButton("Applied")),
          Tab(child: statusButton("Reviewed")),
          Tab(child: statusButton("Interview")),
          Tab(child: statusButton("Selected")),
          Tab(child: statusButton("Rejected")),
        ],
      ),
    );
  }

  Padding statusButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding + 8,
      ),
      child: Text(text),
    );
  }

  AppBar myCustomAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Activity'),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
    );
  }
}
