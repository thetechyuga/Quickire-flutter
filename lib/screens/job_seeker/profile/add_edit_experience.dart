import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/experience_journey.dart';
import 'package:quickhire/services/user/experience_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';
import 'package:quickhire/widgets/custom_input_box.dart';
import 'package:quickhire/widgets/year_picker_dialog.dart';

class AddEditExperienceScreen extends StatefulWidget {
  final ExperienceJourney? experience;

  const AddEditExperienceScreen({super.key, this.experience});

  @override
  State<AddEditExperienceScreen> createState() =>
      _AddEditExperienceScreenState();
}

class _AddEditExperienceScreenState extends State<AddEditExperienceScreen> {
  final SecureStorageService storage = SecureStorageService();
  final ExperienceApiService experienceApiService = ExperienceApiService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roleController;
  late TextEditingController _companyNameController;
  late TextEditingController _departmentController;
  late TextEditingController _industryController;
  late TextEditingController _skillsController;
  late TextEditingController _startYearController;
  late TextEditingController _endYearController;
  String selectedExperience = "Full-Time";

  Future<void> _selectYear(
      BuildContext context, TextEditingController controller) async {
    final selectedYear = await showDialog<int>(
      context: context,
      builder: (context) {
        return YearPickerDialog(
          selectedYear: int.tryParse(controller.text) ?? DateTime.now().year,
          startYear: 2000,
          endYear: DateTime.now().year + 5,
          onYearSelected: (year) {
            controller.text = year.toString();
          },
        );
      },
    );
  }

  getUserId() async {
    String userDetails = await storage.readUserId() ?? '';
    if (userDetails == '') {
      debugPrint("User details is empty");
    }
    int userId = int.parse(userDetails);
    return userId;
  }

  @override
  void initState() {
    super.initState();
    _roleController =
        TextEditingController(text: widget.experience?.role ?? '');
    _companyNameController =
        TextEditingController(text: widget.experience?.companyName ?? '');
    _departmentController =
        TextEditingController(text: widget.experience?.department ?? '');
    _industryController =
        TextEditingController(text: widget.experience?.industry ?? '');
    _skillsController =
        TextEditingController(text: widget.experience?.skills ?? '');
    _startYearController = TextEditingController(
        text: widget.experience?.startYear.toString() ?? '');
    _endYearController = TextEditingController(
        text: widget.experience?.endYear.toString() ?? '');
    selectedExperience = widget.experience?.experienceType ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _roleController.dispose();
    _companyNameController.dispose();
    _departmentController.dispose();
    _industryController.dispose();
    _skillsController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
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

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (int.parse(_startYearController.text) >
          int.parse(_endYearController.text)) {
        showErrorDialog("Invalid Year Selection",
            "The start year cannot be after the end year. Please select a valid start and end year.");
      }
      final experience = ExperienceJourney(
        userDetails: await getUserId(),
        role: _roleController.text.trim(),
        companyName: _companyNameController.text.trim(),
        department: _departmentController.text.trim(),
        industry: _industryController.text.trim(),
        skills: _skillsController.text.trim(),
        startYear: int.parse(_startYearController.text.trim()),
        endYear: int.parse(_endYearController.text.trim()),
        experienceType: selectedExperience.trim(),
      );

      if (widget.experience == null) {
        bool success =
            await experienceApiService.createExperienceJourney(experience);
        if (success) {
          Navigator.pop(context, true);
        } else {
          showErrorDialog('Unable to Add Experience',
              'There was an error adding your experience. Please try again later or check your input fields.');
        }
      } else {
        experience.experienceJourneyId = widget.experience?.experienceJourneyId;
        bool success =
            await experienceApiService.updateExperienceJourney(experience);
        if (success) {
          Navigator.pop(context, true);
        } else {
          showErrorDialog('Unable to Update Experience',
              'There was an error adding your experience. Please try again later or check your input fields.');
        }
      }
    }
  }

  void deleteExperience() async {
    if (widget.experience != null) {
      int experienceJourneyId = widget.experience?.experienceJourneyId ?? 9;
      bool success = await experienceApiService
          .deleteExperienceJourney(experienceJourneyId);
      if (success) {
        Navigator.pop(context, true);
      } else {
        showErrorDialog('Unable to Delete Experience',
            'There was an error adding your experience. Please try again later or check your input fields.');
      }
    }
  }

  void confirmDeletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this experience?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteExperience();
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  top: horizontalPadding,
                ),
                child: Text(
                  'Job Details',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: poppinsSemiBold,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
              createFields('Job Role', 'e.g. Flutter Developer',
                  _roleController, "Job role can't be empty"),
              createFields('Deaprtment', 'e.g. IT Department',
                  _departmentController, "Department can't be empty"),
              createFields('Skills Used', 'e.g. Android, Kotlin, Dart',
                  _skillsController, "Skills can't be empty"),
              const SizedBox(
                height: 12,
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  top: verticalPadding,
                ),
                child: Text(
                  'Company Details',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: poppinsSemiBold,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
              createFields('Company Name', 'e.g. Atlassian',
                  _companyNameController, "Company Name can't be empty"),
              createFields('Industry', 'e.g. Software Product',
                  _industryController, "Industry can't be empty"),
              const SizedBox(
                height: 12,
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  top: verticalPadding,
                ),
                child: Text(
                  'Employment Details',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: poppinsSemiBold,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
              yearTextFeild(_startYearController, 'Start year', false),
              yearTextFeild(_endYearController, 'End year', false),
              // createFields('Start year', 'e.g. 2022', _startYearController),
              // createFields('End year', 'e.g. 2024', _endYearController),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 28.0,
                ),
                child: Text(
                  'Employment Type',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(
                      label: const Text('Full-Time'),
                      selected: selectedExperience == 'Full-Time',
                      onSelected: (bool selected) {
                        setState(() {
                          selectedExperience =
                              selected ? 'Full-Time' : selectedExperience;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Part-Time'),
                      selected: selectedExperience == 'Part-Time',
                      onSelected: (bool selected) {
                        setState(() {
                          selectedExperience =
                              selected ? 'Part-Time' : selectedExperience;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Remote'),
                      selected: selectedExperience == 'Remote',
                      onSelected: (bool selected) {
                        setState(() {
                          selectedExperience =
                              selected ? 'Remote' : selectedExperience;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    widget.experience == null
                        ? 'Add Experience'
                        : 'Update Experience',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: whiteText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column createFields(String title, String hint,
      TextEditingController textEditingController, String errorMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 28.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: notActive,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomInputBox(
          hint: hint,
          svgIconPath: 'assets/icons/mail.svg',
          enabled: true,
          controller: textEditingController,
          isPassword: false,
          hasFocus: false,
          needSvg: false,
          errorText: errorMsg,
        ),
      ],
    );
  }

  AppBar myCustomAppBar() {
    return AppBar(
      title: Text(
        widget.experience == null ? 'Add Experience' : 'Edit Experience',
      ),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
      actions: widget.experience != null
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: confirmDeletionDialog,
              ),
            ]
          : [],
    );
  }

  Focus yearTextFeild(TextEditingController textEditingController, String hint,
      bool hasFocus) {
    int currentYear = DateTime.now().year;
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          hasFocus = hasFocus;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
        ),
        child: TextFormField(
          controller: textEditingController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            hintText: hint,
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: secondaryText,
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                width: 2.0,
                color: hasFocus ? primaryColor : Colors.transparent,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: notActive,
              ),
              onPressed: () => _selectYear(context, textEditingController),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            int year = int.parse(value ?? "0");
            if (value == null || value.isEmpty || year > currentYear) {
              return 'Please enter the valid year';
            }
            return null;
          },
        ),
      ),
    );
  }
}
