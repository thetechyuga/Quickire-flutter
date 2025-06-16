import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/screens/job_seeker/job_details_screen.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/widgets/custom_app_bar.dart';
import 'package:quickhire/widgets/job_tile.dart';
//import 'package:skeletonizer/skeletonizer.dart';
import 'package:shimmer/shimmer.dart';


class JobPostingScreen extends StatefulWidget {
  const JobPostingScreen({super.key});

  @override
  State<JobPostingScreen> createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  JobApiService jobApiService = JobApiService();
  late Future<List<Job>> _jobFuture;
  final List<String> options = [
    "All Status",
    "Active",
    "Inactive",
  ];

  void onJobUpdated() {
    setState(() {
      _jobFuture = jobApiService.fetchEmployerJobs(null);
    });
  }

  fetchInitData() {
    _jobFuture = jobApiService.fetchEmployerJobs(null);
  }

  navigateToJob(Job job) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          job: job,
          btnColor: primaryColor,
          btnText: 'View Applications',
        ),
      ),
    );
    if (result) {
      setState(() {
        _jobFuture = jobApiService.fetchEmployerJobs(null);
      });
    }
  }

  onOptionClick(String status) async {
    List<Job> updatedJobs;

    if (status == "Active") {
      updatedJobs = await jobApiService.fetchEmployerJobs(true);
    } else if (status == "Inactive") {
      updatedJobs = await jobApiService.fetchEmployerJobs(false);
    } else {
      updatedJobs = await jobApiService.fetchEmployerJobs(null);
    }

    setState(() {
      _jobFuture = Future.value(updatedJobs);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar("Job Postings"),
      body: Column(
        children: [
          tabBarMenu(),
          const SizedBox(
            height: verticalPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FutureBuilder(
                  future: _jobFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return jobList(true, emptyJob);
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Failed to load jobs'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No jobs posted'));
                    } else {
                      List<Job> jobs = snapshot.data!;
                      return jobList(false, jobs);
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  // Column jobList(bool isLoading, List<Job> jobs) {
  //   return Column(
  //     children: [
  //       Skeletonizer(
  //         enabled: isLoading,
  //         child: ListView.builder(
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           itemCount: jobs.length,
  //           itemBuilder: (context, index) {
  //             final job = jobs[index];
  //             String btnText = job.isActive ? "Active" : "Inactive";
  //             Color btnColor =
  //                 job.isActive ? primaryColor : rejectedButtonColor;
  //             return JobTile(
  //               navigateToJob: () => navigateToJob(job),
  //               buttonColor: btnColor,
  //               buttonText: btnText,
  //               job: job,
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

      Column jobList(bool isLoading, List<Job> jobs) {
      return Column(
        children: [
          isLoading
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5, // Number of shimmer placeholders
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 14,
                                      width: double.infinity,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 14,
                                      width: 120,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    String btnText = job.isActive ? "Active" : "Inactive";
                    Color btnColor =
                        job.isActive ? primaryColor : rejectedButtonColor;
                    return JobTile(
                      navigateToJob: () => navigateToJob(job),
                      buttonColor: btnColor,
                      buttonText: btnText,
                      job: job,
                    );
                  },
                ),
        ],
      );
    }

  DefaultTabController tabBarMenu() {
    return DefaultTabController(
      length: 3,
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
          Tab(child: statusButton("All Status")),
          Tab(child: statusButton("Active")),
          Tab(child: statusButton("Inactive")),
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
