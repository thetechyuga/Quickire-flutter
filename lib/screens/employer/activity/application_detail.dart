import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/education_journey.dart';
import 'package:quickhire/models/experience_journey.dart';
import 'package:quickhire/models/user_details.dart';
import 'package:quickhire/screens/employer/message/message_screen.dart';
import 'package:quickhire/services/auth/auth_api_service.dart';
import 'package:quickhire/services/messages/conversation_api_response.dart';
import 'package:quickhire/services/messages/messages_api_service.dart';
import 'package:quickhire/services/user/education_api_service.dart';
import 'package:quickhire/services/user/experience_api_service.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/education_tile.dart';
import 'package:quickhire/widgets/experience_tile.dart';
import 'package:quickhire/widgets/profile_banner.dart';
import 'package:quickhire/widgets/skill_tile.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final int userId;
  final int applicationId;
  const ApplicationDetailScreen({
    super.key,
    required this.userId,
    required this.applicationId,
  });

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  UserDetails? user;

  SecureStorageService storageService = SecureStorageService();
  String employerId = '';

  final AuthApiService authApiService = AuthApiService();
  final UserApiService userApiService = UserApiService();
  final EducationApiService educationApiService = EducationApiService();
  final ExperienceApiService experienceApiService = ExperienceApiService();
  final MessageApiService messageApiService = MessageApiService();

  late Future<List<dynamic>> userFuture;
  late Future<UserDetails> _userFuture;
  late Future<List<EducationJourney>> _educationFuture;
  late Future<List<ExperienceJourney>> _experienceFuture;

  void fetchInitalData() async {
    _userFuture = userApiService.fetchUserById(widget.userId);
    _educationFuture =
        educationApiService.fetchEducationJourneysById(widget.userId);
    _experienceFuture =
        experienceApiService.fetchExperienceJourneysById(widget.userId);
    employerId = await storageService.readUserId() ?? '';
  }

  void messageUser(int userId, String employerId) async {
    List<int> participants = [userId, int.parse(employerId)];
    ConversationApiResponse conversationApiResponse =
        await messageApiService.createConversation(participants);

    if (conversationApiResponse.success) {
      navigateToMessage(conversationApiResponse.conversation!.id, user!.name);
    } else {
      showErrorDialog('Can not Message',
          'We are not able to fulfil request. Kindly try again!', context);
    }
  }

  navigateToMessage(int conversationId, String appBarName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageScreen(
          conversationId: conversationId,
          appBarName: appBarName,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchInitalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  _userFuture,
                  _educationFuture,
                  _experienceFuture,
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("issue is here");
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No user data available.'));
                  } else {
                    UserDetails user = snapshot.data![0] as UserDetails;
                    this.user = user;
                    List<EducationJourney> educationJourney =
                        snapshot.data![1] as List<EducationJourney>;
                    List<ExperienceJourney> experienceJourney =
                        snapshot.data![2] as List<ExperienceJourney>;

                    List<String> skills = user.skills
                        .split(',')
                        .map((skill) => skill.trim())
                        .toList();
                    List<String> languages = user.languages
                        .split(',')
                        .map((skill) => skill.trim())
                        .toList();

                    return Column(
                      children: [
                        ProfileBanner(
                          user: user,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        subHeading(
                          'Experience',
                          '',
                          onNavigate: () {},
                        ),
                        experienceJourneyWidget(experienceJourney),
                        subHeading('Education', '', onNavigate: () {}),
                        educationJourneyWidget(educationJourney),
                        subHeading('Skills', '', enabled: false),
                        SkillTile(
                          headingText: 'Your Skills',
                          skills: skills,
                          onEdit: () => () {},
                        ),
                        subHeading('Languages known', '', enabled: false),
                        SkillTile(
                          headingText: 'Your Languages',
                          skills: languages,
                          onEdit: () {},
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(horizontalPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                messageUser(
                  user!.userId,
                  employerId,
                );
              },
              child: const Text(
                "Message",
                style: TextStyle(
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

  Widget educationJourneyWidget(List<EducationJourney> educationJourney) {
    if (educationJourney.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Center(child: Text('No education journey found for the User')),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: educationJourney.length,
      itemBuilder: (context, index) {
        EducationJourney education = educationJourney[index];
        return EducationTile(
          educationJourney: education,
          onEdit: () {},
        );
      },
    );
  }

  Widget experienceJourneyWidget(List<ExperienceJourney> experienceJourney) {
    if (experienceJourney.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Center(child: Text('No experience journey found for the User')),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: experienceJourney.length,
      itemBuilder: (context, index) {
        ExperienceJourney experience = experienceJourney[index];
        return ExperienceTile(
          experience: experience,
          onEdit: () {},
        );
      },
    );
  }

  Padding subHeading(String heading, String option,
      {bool enabled = true, VoidCallback? onNavigate}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              heading,
              style: const TextStyle(
                color: secondaryText,
                fontWeight: poppinsSemiBold,
                fontSize: mediumFontSize,
              ),
            ),
          ),
          const Spacer(),
          enabled
              ? GestureDetector(
                  onTap: onNavigate,
                  child: Text(
                    option,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: smallFontSize,
                      fontWeight: poppinsRegular,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  AppBar myCustomAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('Application No. ${widget.applicationId}'),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
    );
  }
}
