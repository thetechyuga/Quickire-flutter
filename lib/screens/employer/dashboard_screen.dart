import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/services/application/application_api_service.dart';
import 'package:quickhire/services/application/chart_data_reponse.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/homepage_banner.dart';
import 'package:quickhire/widgets/line_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SecureStorageService storageService = SecureStorageService();
  ApplicationApiService applicationApiService = ApplicationApiService();
  JobApiService jobApiService = JobApiService();
  late Future<ChartDataResponse> _chartFuture;
  late Future<Map<String, dynamic>> _statusFuture;
  String? username = '';

  void loadUsername() async {
    String? username = await storageService.readUsername();
    setState(() {
      username = username;
    });
  }

  fetchChartData() {
    _chartFuture = applicationApiService.fetchApplicationData();
    _statusFuture = jobApiService.fetchEmployerJobsStatus();
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
    fetchChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const HomepageBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding + 8,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Statistics',
                    style: TextStyle(
                      fontWeight: poppinsSemiBold,
                      fontSize: largeFontSize,
                      color: primaryColor,
                    ),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      _chartFuture,
                      _statusFuture,
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data available'));
                      } else {
                        final chartData = snapshot.data![0];
                        final jobStatusData = snapshot.data![1];
                        final activeJobs = jobStatusData['active_jobs'];
                        final inactiveJobs = jobStatusData['inactive_jobs'];

                        return Column(
                          children: [
                            ApplicationsLineChart(
                              applicationCounts: chartData.applicationCounts,
                              dates: chartData.dates,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Your Job Postings',
                                style: TextStyle(
                                  fontWeight: poppinsSemiBold,
                                  fontSize: largeFontSize,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                jobPostingCards("Active Jobs", activeJobs),
                                jobPostingCards('Inactive Jobs', inactiveJobs),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                right: horizontalPadding,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '*for more details, checkout jobs section!',
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: smallFontSize,
                                    fontWeight: poppinsRegular,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card jobPostingCards(String text, int value) {
    return Card(
      elevation: 0,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: borderColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: secondaryText,
                fontWeight: poppinsSemiBold,
                fontSize: mediumFontSize,
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                color: primaryText,
                fontWeight: poppinsSemiBold,
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize myCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 0,
          left: 8,
          right: 8,
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              username != null
                  ? Text(
                      '${getGreeting()}, $username!',
                      style: const TextStyle(
                        fontSize: smallFontSize,
                        color: secondaryText,
                        fontWeight: poppinsSemiBold,
                      ),
                    )
                  : const CircularProgressIndicator(),
              const Text(
                'Post, Review & Hire',
                style: TextStyle(
                  fontSize: largeFontSize,
                  color: primaryText,
                  fontWeight: poppinsRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
