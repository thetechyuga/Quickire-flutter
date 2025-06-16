import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/user_details.dart';
import 'package:quickhire/services/user/user_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';
import 'package:quickhire/widgets/custom_input_box.dart';

class EditBasicSettings extends StatefulWidget {
  final UserDetails user;
  const EditBasicSettings({
    super.key,
    required this.user,
  });

  @override
  State<EditBasicSettings> createState() => _EditBasicSettingsState();
}

class _EditBasicSettingsState extends State<EditBasicSettings> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController roleTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  final UserApiService userApiService = UserApiService();

  File? _image;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = await cropImage(image);

    setState(() {
      _image = imageTemporary;
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

  @override
  void initState() {
    super.initState();
    usernameTextEditingController.text = widget.user.name;
    if (widget.user.role == "Unkown") {
      roleTextEditingController.text = "";
    } else {
      roleTextEditingController.text = widget.user.role;
    }
    if (widget.user.city == "Unkown") {
      locationTextEditingController.text = "";
    } else {
      locationTextEditingController.text = widget.user.city;
    }
  }

  onupdate() async {
    Map<String, dynamic> data = {
      'username': usernameTextEditingController.text,
      'role': roleTextEditingController.text,
      'city': locationTextEditingController.text,
    };
    final response = await userApiService.patchUser(data);
    if (response.success) {
      Navigator.pop(context, true);
      return;
    }
    showErrorDialog('Update Failed',
        'Failure: user details can not be updated, Kindly try again later');
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: userImage()),
                      const SizedBox(
                        height: verticalPadding,
                      ),
                      headings('Your Username'),
                      CustomInputBox(
                        hint: 'username',
                        svgIconPath: 'assets/icons/profile.svg',
                        enabled: true,
                        controller: usernameTextEditingController,
                        isPassword: false,
                        hasFocus: false,
                      ),
                      headings('Your role'),
                      CustomInputBox(
                        hint: 'role',
                        svgIconPath: 'assets/icons/job.svg',
                        enabled: true,
                        controller: roleTextEditingController,
                        isPassword: false,
                        hasFocus: false,
                      ),
                      headings('Your location'),
                      CustomInputBox(
                        hint: 'location',
                        svgIconPath: 'assets/icons/location2.svg',
                        enabled: true,
                        controller: locationTextEditingController,
                        isPassword: false,
                        hasFocus: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (_image != null) {
                  userApiService.uploadImage(_image!).then((success) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upload Successful')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upload Failed')));
                    }
                  });
                }
              },
              child: const Text(
                "Update Profile Photo",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: whiteText,
                ),
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
                onupdate();
              },
              child: const Text(
                "Update Details",
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

  Padding headings(String headingText) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 28.0,
      ),
      child: Text(
        headingText,
        style: const TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Stack userImage() {
    return Stack(clipBehavior: Clip.none, children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: secondaryColor,
        backgroundImage: _image != null
            ? FileImage(_image!) as ImageProvider
            : NetworkImage(BASE_URL + widget.user.userPhoto),
      ),
      Positioned(
        bottom: -10,
        right: -10,
        child: GestureDetector(
          onTap: pickImage,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, size: 24, color: whiteText),
              onPressed: pickImage,
            ),
          ),
        ),
      ),
    ]);
  }

  AppBar myCustomAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Profile Settings'),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
    );
  }
}
