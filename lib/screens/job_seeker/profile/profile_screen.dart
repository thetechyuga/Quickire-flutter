import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/education_journey.dart';
import 'package:quickhire/models/experience_journey.dart';
import 'package:quickhire/models/subscription.dart';
import 'package:quickhire/models/user_details.dart';
import 'package:quickhire/screens/job_seeker/profile/add_edit_education.dart';
import 'package:quickhire/screens/job_seeker/profile/add_edit_experience.dart';
import 'package:quickhire/screens/job_seeker/profile/edit_basic_settings.dart';
import 'package:quickhire/screens/job_seeker/profile/edit_languages.dart';
import 'package:quickhire/screens/job_seeker/profile/edit_skills.dart';
import 'package:quickhire/screens/subscription/subscription_screen.dart';
import 'package:quickhire/services/auth/auth_api_service.dart';
import 'package:quickhire/services/user/education_api_service.dart';
import 'package:quickhire/services/user/experience_api_service.dart';
import 'package:quickhire/services/user/subscription_api_service.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/widgets/education_tile.dart';
import 'package:quickhire/widgets/experience_tile.dart';
import 'package:quickhire/widgets/profile_banner.dart';
import 'package:quickhire/widgets/skill_tile.dart';
import 'package:quickhire/widgets/subscription_details_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDetails? user;
  final AuthApiService authApiService = AuthApiService();
  final UserApiService userApiService = UserApiService();
  final EducationApiService educationApiService = EducationApiService();
  final ExperienceApiService experienceApiService = ExperienceApiService();
  final SubscriptionApiService subscriptionApiService =
      SubscriptionApiService();
  late Future<List<dynamic>> userFuture;
  late Future<UserDetails> _userFuture;
  late Future<List<EducationJourney>> _educationFuture;
  late Future<List<ExperienceJourney>> _experienceFuture;
  late Future<Subscription> _subscriptionFuture;

  void fetchInitalData() {
    _userFuture = userApiService.fetchUser();
    _educationFuture = educationApiService.fetchEducationJourneys();
    _experienceFuture = experienceApiService.fetchExperienceJourneys();
    _subscriptionFuture = subscriptionApiService.fetchSubscription();
  }

  @override
  void initState() {
    super.initState();
    fetchInitalData();
  }

  void _updateEducationData() async {
    final updatedEducation = await educationApiService.fetchEducationJourneys();
    setState(() {
      _educationFuture = Future.value(updatedEducation);
    });
  }

  navigateToSubscriptionPlansScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubscriptionPlanScreen()),
    );

    if (result == true) {
      _updateSubscriptionData();
    }
  }

  void _updateSubscriptionData() async {
    final updatedSubscription =
        await subscriptionApiService.fetchSubscription();
    setState(() {
      _subscriptionFuture = Future.value(updatedSubscription);
    });
  }

  void _updateExperienceData() async {
    final updatedExperience =
        await experienceApiService.fetchExperienceJourneys();
    setState(() {
      _experienceFuture = Future.value(updatedExperience);
    });
  }

  void _updateUserDetails() async {
    final updatedUserDetails = await userApiService.fetchUser();
    setState(() {
      _userFuture = Future.value(updatedUserDetails);
    });
  }

  void navigateToAddEditExperienceScreen(
      {ExperienceJourney? experience}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddEditExperienceScreen(experience: experience)),
    );

    if (result == true) {
      debugPrint("recall is done");
      _updateExperienceData();
    }
  }

  void navigateToAddEditEducationScreen({EducationJourney? education}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditEducationScreen(education: education)),
    );

    if (result == true) {
      debugPrint("recall is done");
      _updateEducationData();
    }
  }

  void navigateToEditSkillScreen({List<String>? skills}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditSkillsScreen(userSkills: skills ?? [])),
    );

    if (result == true) {
      debugPrint("recall is done");
      _updateUserDetails();
    }
  }

  void navigateToEditSLanguageScreen({List<String>? languages}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditLanguagesScreen(userLanguages: languages ?? [])),
    );

    if (result == true) {
      debugPrint("recall is done");
      _updateUserDetails();
    }
  }

  void _onMenuOptionSelected(String value) async {
    switch (value) {
      case 'edit':
        navigateToBasicSettings();
        break;
      case 'terms':
        navigateToLink(termsUrl);
        break;
      case 'privacy':
        navigateToLink(policyUrl);
        break;
      case 'logout':
        bool result = await authApiService.logout();
        if (result) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to log out. Please try again.')),
          );
        }
        break;
      default:
        break;
    }
  }

  navigateToBasicSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBasicSettings(
          user: user!,
        ),
      ),
    );

    if (result == true) {
      debugPrint("recall is done");
      _updateUserDetails();
    }
  }

  navigateToLink(Uri link) async {
    !await launchUrl(
      link,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<List<dynamic>>(
              future: Future.wait([
                _userFuture,
                _educationFuture,
                _experienceFuture,
                _subscriptionFuture,
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text  ('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No user data available.'));
                } else {
                  UserDetails user = snapshot.data![0] as UserDetails;
                  this.user = user;
                  List<EducationJourney> educationJourney =
                      snapshot.data![1] as List<EducationJourney>;
                  List<ExperienceJourney> experienceJourney =
                      snapshot.data![2] as List<ExperienceJourney>;

                  Subscription subscription = snapshot.data![3] as Subscription;

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
                        'Add',
                        onNavigate: navigateToAddEditExperienceScreen,
                      ),
                      experienceJourneyWidget(experienceJourney),
                      subHeading('Education', 'Add',
                          onNavigate: navigateToAddEditEducationScreen),
                      educationJourneyWidget(educationJourney),
                      subHeading('Skills', 'Add', enabled: false),
                      SkillTile(
                        headingText: 'Your Skills',
                        skills: skills,
                        onEdit: () => navigateToEditSkillScreen(skills: skills),
                      ),
                      subHeading('Languages known', 'Add', enabled: false),
                      SkillTile(
                        headingText: 'Your Languages',
                        skills: languages,
                        onEdit: () =>
                            navigateToEditSLanguageScreen(languages: languages),
                      ),
                      SubscriptionDetailsCard(
                          isActive: subscription.isActive,
                          navigateToSubscriptionPlansScreen:
                              navigateToSubscriptionPlansScreen,
                          parsedStartDate: subscription.startDate,
                          parsedEndDate: subscription.endDate),
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

  Widget educationJourneyWidget(List<EducationJourney> educationJourney) {
    if (educationJourney.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Center(child: Text('No education journey found, Add now!')),
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
          onEdit: () => navigateToAddEditEducationScreen(education: education),
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
        child: Center(child: Text('No experience journey found, Add now!')),
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
          onEdit: () =>
              navigateToAddEditExperienceScreen(experience: experience),
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
      title: const Text('Profile'),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: _onMenuOptionSelected,
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'terms',
                child: Text('Terms and Conditions'),
              ),
              const PopupMenuItem<String>(
                value: 'privacy',
                child: Text('Privacy Policy'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Log Out'),
              ),
            ];
          },
        )
      ],
    );
  }
}
