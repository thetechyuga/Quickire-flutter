import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/company.dart';
import 'package:quickhire/models/subscription.dart';
import 'package:quickhire/screens/employer/profile/edit_company_profile_screen.dart';
import 'package:quickhire/screens/subscription/subscription_screen.dart';
import 'package:quickhire/services/auth/auth_api_service.dart';
import 'package:quickhire/services/company/company_api_service.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/services/user/subscription_api_service.dart';
import 'package:quickhire/widgets/subscription_details_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyProfileScreen extends StatefulWidget {
  final int? companyId;
  const CompanyProfileScreen({super.key, this.companyId});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  CompanyApiService companyApiService = CompanyApiService();
  AuthApiService authApiService = AuthApiService();
  JobApiService jobApiService = JobApiService();
  SubscriptionApiService subscriptionApiService = SubscriptionApiService();

  late Future<Company> _companyFuture;
  late Future<Map<String, dynamic>> _statusFuture;
  late Future<Subscription> _subscriptionFuture;

  void fetchInitData() {
    bool isNull = widget.companyId == null;
    _companyFuture = isNull
        ? companyApiService.fetchCompanyDetails()
        : companyApiService.fetchCompanyDetailsById(widget.companyId!);
    _statusFuture = jobApiService.fetchEmployerJobsStatus();
    _subscriptionFuture = subscriptionApiService.fetchCompanySubscription();
  }

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }

  navigateToEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditCompanyProfileScreen()),
    );

    if (result == true) {
      setState(() {
        fetchInitData();
      });
    }
  }

  navigateToSubscriptionPlansScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubscriptionPlanScreen(
          isUser: false,
        ),
      ),
    );

    if (result == true) {
      _updateSubscriptionData();
    }
  }

  void _updateSubscriptionData() async {
    final updatedSubscription =
        await subscriptionApiService.fetchCompanySubscription();
    setState(() {
      _subscriptionFuture = Future.value(updatedSubscription);
    });
  }

  void _onMenuOptionSelected(String value) async {
    switch (value) {
      case 'edit':
        navigateToEditScreen();

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

  navigateToLink(Uri link) async {
    !await launchUrl(
      link,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.companyId == null
          ? myCustomAppBar('Company Profile')
          : myCustomAppBar('Company Details'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  _statusFuture,
                  _companyFuture,
                  _subscriptionFuture,
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text('No company data available.'));
                  } else {
                    Company company = snapshot.data![1];
                    final jobStatusData = snapshot.data![0];
                    Subscription subscription =
                        snapshot.data![2] as Subscription;
                    final activeJobs = jobStatusData['active_jobs'];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loadImagePart(
                          company.companyBackground,
                          company.companyLogo,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.companyName,
                                style: const TextStyle(
                                  fontSize: largeFontSize,
                                  color: primaryText,
                                  fontWeight: poppinsSemiBold,
                                ),
                              ),
                              Text(
                                company.companyTitle,
                                style: const TextStyle(
                                  fontSize: mediumFontSize,
                                  color: secondaryText,
                                  fontWeight: poppinsSemiBold,
                                ),
                              ),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              Text(
                                company.companyDesc,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: smallFontSize,
                                  color: primaryText,
                                  fontWeight: poppinsRegular,
                                ),
                              ),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              const Text(
                                'Company Details',
                                style: TextStyle(
                                  fontSize: largeFontSize,
                                  color: primaryText,
                                  fontWeight: poppinsSemiBold,
                                ),
                              ),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              featureText(
                                  'Location',
                                  'assets/icons/location.svg',
                                  company.location),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              featureText('Company Website',
                                  'assets/icons/link.svg', company.companyLink,
                                  isUrl: true),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              featureText('LinkedIn', 'assets/icons/link.svg',
                                  company.linkedinLink,
                                  isUrl: true),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              featureText(
                                  'Industry',
                                  'assets/icons/employer.svg',
                                  company.industry),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              featureText(
                                  'Founded Year',
                                  'assets/icons/founded.svg',
                                  company.foundedYear == "0"
                                      ? ''
                                      : company.foundedYear),
                              const SizedBox(
                                height: verticalPadding,
                              ),
                              featureText('Posted Jobs', 'assets/icons/job.svg',
                                  'Active Jobs: $activeJobs'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
            ),
          ),
        ],
      ),
    );
  }

  AppBar myCustomAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
      actions: widget.companyId != null
          ? []
          : [
              PopupMenuButton<String>(
                onSelected: _onMenuOptionSelected,
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit Company Profile'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'terms',
                      child: Text('Terms and Conditions'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'guidelines',
                      child: Text('Community Guidelines'),
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

  Column featureText(String heading, String svgAsset, String value,
      {bool isUrl = false}) {
    Uri url = Uri.parse('www.google.com');
    if (isUrl) {
      url = Uri.parse(value);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: smallFontSize,
            color: primaryText,
            fontWeight: poppinsSemiBold,
          ),
        ),
        const SizedBox(
          height: verticalPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 20,
              height: 20,
              color: secondaryText,
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
              child: isUrl
                  ? GestureDetector(
                      onTap: () async {
                        !await launchUrl(
                          url,
                        );
                      },
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: smallFontSize,
                          fontWeight: poppinsRegular,
                          color: secondaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: smallFontSize,
                        fontWeight: poppinsRegular,
                        color: secondaryText,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Stack loadImagePart(String bgImage, String profileImg) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 180.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(BASE_URL + bgImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: -50.0,
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(BASE_URL + profileImg),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
