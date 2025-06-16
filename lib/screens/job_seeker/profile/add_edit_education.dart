import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/education_journey.dart';
import 'package:quickhire/services/user/education_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';
import 'package:quickhire/widgets/custom_input_box.dart';
import 'package:quickhire/widgets/year_picker_dialog.dart';

class AddEditEducationScreen extends StatefulWidget {
  final EducationJourney? education;

  const AddEditEducationScreen({super.key, this.education});

  @override
  State<AddEditEducationScreen> createState() => _AddEditEducationScreenState();
}

class _AddEditEducationScreenState extends State<AddEditEducationScreen> {
  final SecureStorageService storage = SecureStorageService();
  final EducationApiService educationApiService = EducationApiService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _courseController;
  late TextEditingController _instituteNameController;
  late TextEditingController _startYearController;
  late TextEditingController _endYearController;
  String selectedEducationType = "Full-Time";

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
    _courseController =
        TextEditingController(text: widget.education?.course ?? '');
    _instituteNameController =
        TextEditingController(text: widget.education?.instituteName ?? '');
    _startYearController = TextEditingController(
        text: widget.education?.startYear.toString() ?? '');
    _endYearController =
        TextEditingController(text: widget.education?.endYear.toString() ?? '');
    selectedEducationType = widget.education?.courseType ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _courseController.dispose();
    _instituteNameController.dispose();
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
      final education = EducationJourney(
        userDetails: await getUserId(),
        course: _courseController.text.trim(),
        instituteName: _instituteNameController.text.trim(),
        startYear: int.parse(_startYearController.text.trim()),
        endYear: int.parse(_endYearController.text.trim()),
        courseType: selectedEducationType.trim(),
      );

      if (widget.education == null) {
        bool success =
            await educationApiService.createEducationJourney(education);
        if (success) {
          Navigator.pop(context, true);
        } else {
          showErrorDialog('Unable to Add Education',
              'There was an error adding your education. Please try again later or check your input fields.');
        }
      } else {
        education.educationJourneyId = widget.education?.educationJourneyId;
        bool success =
            await educationApiService.updateEducationJourney(education);
        if (success) {
          Navigator.pop(context, true);
        } else {
          showErrorDialog('Unable to Update Education',
              'There was an error adding your education. Please try again later or check your input fields.');
        }
      }
    }
  }

  void deleteEducation() async {
    if (widget.education != null) {
      int educationJourneyId = widget.education?.educationJourneyId ?? 9;
      bool success =
          await educationApiService.deleteEducationJourney(educationJourneyId);
      if (success) {
        Navigator.pop(context, true);
      } else {
        showErrorDialog('Unable to Delete Education',
            'There was an error adding your education. Please try again later or check your input fields.');
      }
    }
  }

  void confirmDeletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this education?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteEducation();
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
                  'Course Details',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: poppinsSemiBold,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
              createFields('Course', 'e.g. Btech, Computer Science',
                  _courseController, "Course name can't be empty"),
              createFields('Institute', 'e.g. Indian Institute of Technology',
                  _instituteNameController, "Instiute name can't be empty"),

              const SizedBox(
                height: 12,
              ),
              const Divider(),

              yearTextFeild(_startYearController, 'Start year', false, false),
              yearTextFeild(_endYearController, 'End year', false, true),
              // createFields('Start year', 'e.g. 2022', _startYearController),
              // createFields('End year', 'e.g. 2024', _endYearController),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 28.0,
                ),
                child: Text(
                  'Course Type',
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
                      selected: selectedEducationType == 'Full-Time',
                      onSelected: (bool selected) {
                        setState(() {
                          selectedEducationType =
                              selected ? 'Full-Time' : selectedEducationType;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Part-Time'),
                      selected: selectedEducationType == 'Part-Time',
                      onSelected: (bool selected) {
                        setState(() {
                          selectedEducationType =
                              selected ? 'Part-Time' : selectedEducationType;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Remote'),
                      selected: selectedEducationType == 'Remote',
                      onSelected: (bool selected) {
                        setState(() {
                          selectedEducationType =
                              selected ? 'Remote' : selectedEducationType;
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
                    widget.education == null
                        ? 'Add Education'
                        : 'Update Education',
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
        widget.education == null ? 'Add Education' : 'Edit Education',
      ),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
      actions: widget.education != null
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
      bool hasFocus, bool isFutureProof) {
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
            if (value == null ||
                value.isEmpty ||
                (!isFutureProof && year > currentYear)) {
              return 'Please enter the valid year';
            }
            return null;
          },
        ),
      ),
    );
  }
}
