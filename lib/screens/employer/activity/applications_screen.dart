import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/application.dart';
import 'package:quickhire/screens/employer/activity/application_detail.dart';
import 'package:quickhire/services/application/application_api_service.dart';
import 'package:quickhire/widgets/application_tile.dart';
import 'package:quickhire/widgets/custom_app_bar.dart';

class ApplicationsScreen extends StatefulWidget {
  final int jobId;
  const ApplicationsScreen({super.key, required this.jobId});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  ApplicationApiService applicationApiService = ApplicationApiService();
  late Future<List<Application>?> _applicationFuture;
  final List<String> options = [
    'All Status',
    'Applied',
    'Reviewed',
    'Interview',
    'Selected',
    'Rejected',
  ];

  fetchInitData() {
    _applicationFuture =
        applicationApiService.fetchApplicationsByJobId(widget.jobId, null);
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
    try {
      if (status == "All Status") {
        updatedApplications = await applicationApiService
            .fetchApplicationsByJobId(widget.jobId, null);
      } else {
        updatedApplications = await applicationApiService
            .fetchApplicationsByJobId(widget.jobId, status);
      }
      setState(() {
        _applicationFuture = Future.value(updatedApplications);
      });
    } catch (e) {
      updatedApplications = [];
      setState(() {
        _applicationFuture = Future.value(updatedApplications);
      });
    }
  }

  navigateToApplicationDetail(int userId, int applicationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationDetailScreen(
          userId: userId,
          applicationId: applicationId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar("Applications"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  tabBarOptions(),
                  Center(
                    child: FutureBuilder<List<Application>?>(
                      future: _applicationFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          debugPrint('i am here');
                          return Center(
                              child: Text(
                                  snapshot.error.toString().replaceAll('Exception:', '')));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child:
                                  Text('No applications found for this job'));
                        } else {
                          List<Application> applications = snapshot.data!;

                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final application = applications[index];
                              return ApplicationTile(
                                  btnColor: getBtnColor(application),
                                  user: application.userId,
                                  navigateToUserScreen: () => {
                                        navigateToApplicationDetail(
                                          application.userId.userId,
                                          application.applicationId,
                                        ),
                                      });
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
}
