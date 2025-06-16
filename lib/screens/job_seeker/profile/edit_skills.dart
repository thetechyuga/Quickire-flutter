import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';

class EditSkillsScreen extends StatefulWidget {
  final List<String> userSkills;
  const EditSkillsScreen({super.key, required this.userSkills});

  @override
  State<EditSkillsScreen> createState() => _EditSkillsScreenState();
}

class _EditSkillsScreenState extends State<EditSkillsScreen> {
  List<String> filteredSkills = [];
  List<String> selectedSkills = [];
  TextEditingController searchController = TextEditingController();
  UserApiService userApiService = UserApiService();
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    filteredSkills = skills;
    selectedSkills = widget.userSkills;
    debugPrint(selectedSkills.toString());
  }

  @override
  void dispose() {
    searchController.dispose();
    debounceTimer?.cancel();
    super.dispose();
  }

  void filterSkills(String query) {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final List<String> filtered = skills.where((skill) {
        return skill.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredSkills = filtered;
      });
    });
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          message: message,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void updateSkills() async {
    String skills = selectedSkills.join(',');
    Map<String, dynamic> data = {
      'skills': skills,
    };
    final response = await userApiService.patchUser(data);
    if (response.success) {
      Navigator.pop(context, true);
    } else {
      showErrorDialog('Unable to Update Skills',
          'There was an error updating your skills. Please try again later or check your input fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final unselectedSkills = filteredSkills
        .where((skill) => !selectedSkills.contains(skill))
        .toList();

    return Scaffold(
      appBar: myCustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Skills',
                border: OutlineInputBorder(),
              ),
              onChanged: filterSkills,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: selectedSkills.length + unselectedSkills.length,
                itemBuilder: (context, index) {
                  if (index < selectedSkills.length) {
                    return ListTile(
                      title: Text(
                        selectedSkills[index],
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.check, color: Colors.green),
                      onTap: () {
                        setState(() {
                          selectedSkills.removeAt(index);
                        });
                      },
                    );
                  } else {
                    String skill =
                        unselectedSkills[index - selectedSkills.length];
                    return ListTile(
                      title: Text(
                        skill,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: selectedSkills.contains(skill)
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          if (selectedSkills.contains(skill)) {
                            selectedSkills.remove(skill);
                          } else {
                            selectedSkills.add(skill);
                          }
                        });
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: updateSkills,
              child: const Text(
                'Update Skills',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: whiteText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar myCustomAppBar() {
    return AppBar(
      title: const Text(
        'Edit Skills',
      ),
      titleTextStyle: const TextStyle(
        color: primaryColor,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
    );
  }
}
