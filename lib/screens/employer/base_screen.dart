import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/screens/employer/activity/job_posting_screen.dart';
import 'package:quickhire/screens/employer/add_edit_job_screen.dart';
import 'package:quickhire/screens/employer/dashboard_screen.dart';
import 'package:quickhire/screens/employer/profile/company_profile_screen.dart';
import 'package:quickhire/screens/job_seeker/conversation_screen.dart';

class EBaseScreen extends StatefulWidget {
  const EBaseScreen({super.key});

  @override
  State<EBaseScreen> createState() => EBaseScreenState();
}

class EBaseScreenState extends State<EBaseScreen> {
  int _selectedScreen = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int? tabIndex = ModalRoute.of(context)?.settings.arguments as int?;
      if (tabIndex != null) {
        setState(() {
          _selectedScreen = tabIndex;
        });
      }
    });
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const JobPostingScreen(),
    const AddEditJobScreen(),
    const ConversationScreen(
      isEmployer: true,
    ),
    const CompanyProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: _screens[_selectedScreen],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/dashboard.svg',
              color: _selectedScreen == 0 ? primaryColor : notActive,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/activity.svg',
              color: _selectedScreen == 1 ? primaryColor : notActive,
            ),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/add.svg',
              color: _selectedScreen == 2 ? primaryColor : notActive,
            ),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/mail.svg',
              color: _selectedScreen == 3 ? primaryColor : notActive,
            ),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              color: _selectedScreen == 4 ? primaryColor : notActive,
            ),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedScreen,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
      ),
    );
  }
}
