import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/screens/job_seeker/job_details_screen.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/widgets/job_tile.dart';
import 'package:quickhire/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final JobApiService jobApiService = JobApiService();
  late TextEditingController searchTextEditingController;
  late Future<List<Job>> _jobFuture;
  final FocusNode _focusNode = FocusNode();

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

  searchJob(String query) async {
    setState(() {
      _jobFuture = jobApiService.searchJob(query);
    });
  }

  @override
  void initState() {
    super.initState();
    searchTextEditingController = TextEditingController();
    searchJob("");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchTextEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(searchTextEditingController,searchJob,_focusNode),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Job>>(
              future: _jobFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No jobs available.'));
                } else {
                  List<Job> jobs = snapshot.data!;
                  return Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return JobTile(
                            navigateToJob: () => navigateToJob(job),
                            buttonColor: primaryColor, // Handle tap if needed
                            buttonText: "Apply",
                            job: job,
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

PreferredSize myCustomAppBar(TextEditingController searchTextEditingController, Function(String) search, FocusNode _focusNode) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(100.0),
    child: Padding(
      padding: const EdgeInsets.only(top: 44),
      child: CustomSearchBar(
        hint: 'Search your Job',
        svgIconPath: 'assets/icons/search.svg',
        enabled: true,
        controller: searchTextEditingController,
        search: search,
        focusNode: _focusNode,
      ),
    ),
  );
}
