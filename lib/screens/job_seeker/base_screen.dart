import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/screens/job_seeker/activity_screen.dart';
import 'package:quickhire/screens/job_seeker/home.dart';
import 'package:quickhire/screens/job_seeker/job_screen.dart';
import 'package:quickhire/screens/job_seeker/profile/profile_screen.dart';
import 'package:quickhire/screens/job_seeker/search_screen.dart';

class JBaseScreen extends StatefulWidget {
  const JBaseScreen({super.key});

  @override
  State<JBaseScreen> createState() => JBaseScreenState();
}

class JBaseScreenState extends State<JBaseScreen> {
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
    const HomeScreen(),
    const ActivityScreen(),
    const SearchScreen(),
    const JobScreen(),
    const ProfileScreen(),
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
              'assets/icons/home.svg',
              color: _selectedScreen == 0 ? primaryColor : notActive,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/activity.svg',
              color: _selectedScreen == 1 ? primaryColor : notActive,
            ),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              color: _selectedScreen == 2 ? primaryColor : notActive,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/job.svg',
              color: _selectedScreen == 3 ? primaryColor : notActive,
            ),
            label: "Jobs",
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
