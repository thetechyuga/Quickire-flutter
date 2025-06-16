import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/screens/job_seeker/conversation_screen.dart';
import 'package:quickhire/screens/job_seeker/job_details_screen.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/homepage_banner.dart';
import 'package:quickhire/widgets/job_tile.dart';
import 'package:quickhire/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final JobApiService jobApiService = JobApiService();
  final SecureStorageService storageService = SecureStorageService();
  String? username = '';

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  void loadUsername() async {
    String? username = await storageService.readUsername();
    setState(() {
      this.username = username;
    });
  }

  navigateToMessgaes() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ConversationScreen(
                isEmployer: false,
              )),
    );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/jhome',
                  arguments: 2,
                );
              },
              child: CustomSearchBar(
                hint: 'Search your job',
                svgIconPath: 'assets/icons/search.svg',
                enabled: false,
                controller: TextEditingController(),
                search: (word) {},
                focusNode: FocusNode(),
              ),
            ),
            const SizedBox(
              height: horizontalPadding,
            ),
            const HomepageBanner(),
            recommendedJobsSection(),
            getSingleJob(1),
            jobMatchesWithYouSection(),
            getSingleJob(2),
          ],
        ),
      ),
    );
  }

  Column getSingleJob(int number) {
    return Column(
      children: [
        FutureBuilder<List<Job>>(
          future: jobApiService.fetchJobs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('No jobs available.'));
            } else if (!snapshot.hasData || snapshot.data!.length < 2) {
              return const Center(child: Text('No jobs available.'));
            } else {
              List<Job> jobs = snapshot.data!;
              Job job = jobs[number - 1];
              return Column(
                children: [
                  JobTile(
                    navigateToJob: () => navigateToJob(
                      job,
                      primaryColor,
                      "Apply",
                    ),
                    buttonColor: primaryColor, // Handle tap if needed
                    buttonText: "Apply",
                    job: job,
                  )
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Padding recommendedJobsSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding + 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Recommended Jobs',
              style: TextStyle(
                color: primaryText,
                fontWeight: poppinsRegular,
                fontSize: largeFontSize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'See all',
              style: TextStyle(
                color: primaryColor,
                fontWeight: poppinsRegular,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding jobMatchesWithYouSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding + 2,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Job matches with you',
              style: TextStyle(
                color: primaryText,
                fontWeight: poppinsRegular,
                fontSize: largeFontSize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'See all',
              style: TextStyle(
                color: primaryColor,
                fontWeight: poppinsRegular,
                fontSize: 16,
              ),
            ),
          ),
        ],
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
            centerTitle: false,
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
                  'Search, Find & Apply',
                  style: TextStyle(
                    fontSize: largeFontSize,
                    color: primaryText,
                    fontWeight: poppinsRegular,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Container(
                  width: 32, // Adjust the size as needed
                  height: 32, // Adjust the size as needed
                  decoration: BoxDecoration(
                    color: secondaryColor, // Background color
                    shape: BoxShape
                        .rectangle, // Ensures the background is a square/rectangle
                    borderRadius: BorderRadius.circular(
                        8), // Adjust the border radius as needed
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      'assets/icons/mail.svg',
                      width: 20,
                      height: 20,
                      color: primaryText, // Adjust the icon color if needed
                    ),
                  ),
                ),
                onPressed: navigateToMessgaes,
              ),
            ]),
      ),
    );
  }
}
