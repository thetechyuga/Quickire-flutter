import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';

class EditLanguagesScreen extends StatefulWidget {
  final List<String> userLanguages;
  const EditLanguagesScreen({super.key, required this.userLanguages});

  @override
  State<EditLanguagesScreen> createState() => _EditLanguagesScreenState();
}

class _EditLanguagesScreenState extends State<EditLanguagesScreen> {
  List<String> filteredLanguages = [];
  List<String> selectedLanguages = [];
  TextEditingController searchController = TextEditingController();
  UserApiService userApiService = UserApiService();
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    filteredLanguages = languages;
    selectedLanguages = widget.userLanguages;
    debugPrint(selectedLanguages.toString());
  }

  @override
  void dispose() {
    searchController.dispose();
    debounceTimer?.cancel();
    super.dispose();
  }

  void filterLanguages(String query) {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final List<String> filtered = languages.where((language) {
        return language.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredLanguages = filtered;
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

  void updateLanguages() async {
    String languages = selectedLanguages.join(',');
    Map<String, dynamic> data = {
      'languages': languages,
    };
    final response = await userApiService.patchUser(data);
    if (response.success) {
      Navigator.pop(context, true);
    } else {
      showErrorDialog('Unable to Update Languages',
          'There was an error updating your languages. Please try again later or check your input fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final unselectedLanguages = filteredLanguages
        .where((language) => !selectedLanguages.contains(language))
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
                labelText: 'Search Languages',
                border: OutlineInputBorder(),
              ),
              onChanged: filterLanguages,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount:
                    selectedLanguages.length + unselectedLanguages.length,
                itemBuilder: (context, index) {
                  if (index < selectedLanguages.length) {
                    return ListTile(
                      title: Text(
                        selectedLanguages[index],
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.check, color: Colors.green),
                      onTap: () {
                        setState(() {
                          selectedLanguages.removeAt(index);
                        });
                      },
                    );
                  } else {
                    String language =
                        unselectedLanguages[index - selectedLanguages.length];
                    return ListTile(
                      title: Text(
                        language,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: selectedLanguages.contains(language)
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          if (selectedLanguages.contains(language)) {
                            selectedLanguages.remove(language);
                          } else {
                            selectedLanguages.add(language);
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
              onPressed: updateLanguages,
              child: const Text(
                'Update Languages',
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
        'Edit Languages',
      ),
      titleTextStyle: const TextStyle(
        color: primaryColor,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
    );
  }
}
