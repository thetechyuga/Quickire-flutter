import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/screens/job_seeker/job_details_screen.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/widgets/custom_app_bar.dart';
import 'package:quickhire/widgets/job_tile.dart';
import 'package:shimmer/shimmer.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final JobApiService jobApiService = JobApiService();

  navigateToJob(Job job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(
          job: job,
          btnColor: primaryColor,
          btnText: 'Apply',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar("Jobs"),
      body: FutureBuilder<List<Job>>(
        future: jobApiService.fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return jobList(true, emptyJob);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs available.'));
          } else {
            List<Job> jobs = snapshot.data!;
            return jobList(false, jobs);
          }
        },
      ),
    );
  }

  // Widget jobList(bool isLoading, List<Job> jobs) {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: Skeletonizer(
  //           enabled: isLoading,
  //           child: ListView.builder(
  //             physics: const BouncingScrollPhysics(),
  //             shrinkWrap: isLoading ? true : false,
  //             itemCount: jobs.length,
  //             itemBuilder: (context, index) {
  //               final job = jobs[index];
  //               String btnText = job.isActive ? "Active" : "Inactive";
  //               Color btnColor =
  //                   job.isActive ? primaryColor : rejectedButtonColor;
  //               return JobTile(
  //                 navigateToJob: () => navigateToJob(job),
  //                 buttonColor: btnColor,
  //                 buttonText: btnText,
  //                 job: job,
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget jobList(bool isLoading, List<Job> jobs) {
  return Column(
    children: [
      Expanded(
        child: isLoading
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5, // Placeholder count during loading
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 14,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 14,
                                    color: Colors.grey,
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
                physics: const BouncingScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  String btnText = job.isActive ? "Active" : "Inactive";
                  Color btnColor = job.isActive ? primaryColor : rejectedButtonColor;
                  return JobTile(
                    navigateToJob: () => navigateToJob(job),
                    buttonColor: btnColor,
                    buttonText: btnText,
                    job: job,
                  );
                },
              ),
      ),
    ],
  );
}
}
