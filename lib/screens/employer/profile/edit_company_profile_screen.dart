import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/company.dart';
import 'package:quickhire/services/company/company_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_expandable_input_box.dart';
import 'package:quickhire/widgets/custom_input_box.dart';
import 'package:quickhire/widgets/year_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class EditCompanyProfileScreen extends StatefulWidget {
  const EditCompanyProfileScreen({super.key});

  @override
  State<EditCompanyProfileScreen> createState() =>
      _EditCompanyProfileScreenState();
}

class _EditCompanyProfileScreenState extends State<EditCompanyProfileScreen> {
  TextEditingController companyNameTextEditingController =
      TextEditingController();
  TextEditingController companyTitleTextEditingController =
      TextEditingController();
  TextEditingController companyDescTextEditingController =
      TextEditingController();
  TextEditingController companyLinkTextEditingController =
      TextEditingController();
  TextEditingController companyLinkedinLinkTextEditingController =
      TextEditingController();
  TextEditingController companyIndustryTextEditingController =
      TextEditingController();
  TextEditingController companyLocationTextEditingController =
      TextEditingController();
  TextEditingController foundedYearTextEditingController =
      TextEditingController();

// left for founded year

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

  File? _backgroundImage, _logo;

  CompanyApiService companyApiService = CompanyApiService();

  late Future<Company> _companyFuture;

  bool isWorking = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }


  @override
  void dispose() {
    super.dispose();
     companyNameTextEditingController.dispose();
     companyTitleTextEditingController.dispose();
     companyDescTextEditingController.dispose();
     companyLinkTextEditingController.dispose();
     companyLinkedinLinkTextEditingController.dispose();
     companyIndustryTextEditingController.dispose();
     companyLocationTextEditingController.dispose();
     foundedYearTextEditingController.dispose();
  }

  void fetchInitData() {
    _companyFuture = companyApiService.fetchCompanyDetails();
  }

  Future pickImage(isLogo) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    // final imageTemporary = File(image.path);
    final imageTemporary = await cropImage(image);


    setState(() {
      isLogo
          ? _logo = imageTemporary
          : _backgroundImage = imageTemporary;
      isWorking = true;
    });
  }

  createCompany() {
    Map<String, dynamic> jsonData = {
      'company_name': companyNameTextEditingController.text,
      'company_title': companyTitleTextEditingController.text,
      'company_desc': companyDescTextEditingController.text,
      'company_link': companyLinkTextEditingController.text,
      'linkedin_link': companyLinkedinLinkTextEditingController.text,
      'industry': companyIndustryTextEditingController.text,
      'location': companyLocationTextEditingController.text,
      'founded_year': (foundedYearTextEditingController.text),
    };
    return jsonData;
  }

  _submitCompanyDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool response = await companyApiService.updateCompany(createCompany());

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update company details: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar('Edit Company Profile'),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(true);
          return false; // This is not strictly necessary as pop() handles it.
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<Company>(
                  future: _companyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No user data available.'));
                    } else {
                      Company company = snapshot.data!;
                      companyNameTextEditingController.text =
                          company.companyName;
                      companyTitleTextEditingController.text =
                          company.companyTitle;
                      companyDescTextEditingController.text =
                          company.companyDesc;
                      companyLinkTextEditingController.text =
                          company.companyLink;
                      companyLinkedinLinkTextEditingController.text =
                          company.linkedinLink;
                      companyIndustryTextEditingController.text =
                          company.industry;
                      companyLocationTextEditingController.text =
                          company.location;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          loadImagePart(
                            company.companyBackground,
                            company.companyLogo,
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: verticalPadding),
                              child: Text(
                                'Info: Tap the images to edit!',
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  fontWeight: poppinsRegular,
                                ),
                              ),
                            ),
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
                                headings('Company Name'),
                                CustomInputBox(
                                  hint: 'Company Name',
                                  needSvg: false,
                                  svgIconPath: 'assets/icons/profile.svg',
                                  enabled: true,
                                  controller: companyNameTextEditingController,
                                  isPassword: false,
                                  hasFocus: false,
                                ),
                                headings('Company Title'),
                                CustomInputBox(
                                  hint: 'Company Title',
                                  needSvg: false,
                                  svgIconPath: 'assets/icons/profile.svg',
                                  enabled: true,
                                  controller: companyTitleTextEditingController,
                                  isPassword: false,
                                  hasFocus: false,
                                ),
                                headings('Company Description'),
                                CustomExpandableInputBox(
                                  hint: 'Company Description',
                                  enabled: true,
                                  controller: companyDescTextEditingController,
                                  hasFocus: false,
                                ),
                                headings('Company Website Url'),
                                CustomInputBox(
                                  hint: 'eg. www.google.com',
                                  needSvg: false,
                                  svgIconPath: 'assets/icons/profile.svg',
                                  enabled: true,
                                  controller: companyLinkTextEditingController,
                                  isPassword: false,
                                  hasFocus: false,
                                ),
                                headings('Company Linkedin Link'),
                                CustomInputBox(
                                  hint: 'eg. www.linkedin.com',
                                  needSvg: false,
                                  svgIconPath: 'assets/icons/profile.svg',
                                  enabled: true,
                                  controller:
                                      companyLinkedinLinkTextEditingController,
                                  isPassword: false,
                                  hasFocus: false,
                                ),
                                headings('Company Industry'),
                                CustomInputBox(
                                  hint: 'eg. Software Product',
                                  needSvg: false,
                                  svgIconPath: 'assets/icons/profile.svg',
                                  enabled: true,
                                  controller:
                                      companyIndustryTextEditingController,
                                  isPassword: false,
                                  hasFocus: false,
                                ),
                                headings('Company Location'),
                                CustomInputBox(
                                  hint: 'Bengaluru, India',
                                  needSvg: false,
                                  svgIconPath: 'assets/icons/profile.svg',
                                  enabled: true,
                                  controller:
                                      companyLocationTextEditingController,
                                  isPassword: false,
                                  hasFocus: false,
                                ),
                                headings('Founded Year'),
                                yearTextFeild(foundedYearTextEditingController,
                                    'Founded Year', false),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
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
                              onPressed:
                                  _isLoading ? null : _submitCompanyDetails,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Update Company Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: whiteText,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            (isWorking)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_backgroundImage != null) {
                          companyApiService
                              .uploadBackground(_backgroundImage!)
                              .then((success) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Background updated Successfully')));
                              setState(() {
                                isWorking = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Upload Failed')));
                            }
                          });
                        }
                        if (_logo != null) {
                          companyApiService.uploadLogo(_logo!).then((success) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Logo updated Successfully')));
                              setState(() {
                                isWorking = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Upload Failed')));
                            }
                          });
                        }
                      },
                      child: const Text(
                        "Upload Photos",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: whiteText,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
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

  Widget loadImagePart(String bgImage, String profileImg) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 180.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _backgroundImage == null
                    ? NetworkImage(BASE_URL+bgImage)
                    : FileImage(_backgroundImage!) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 8.0, // Adjust as needed
            right: 8.0, // Adjust as needed
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
                onPressed: () async {
                  pickImage(false);
                },
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: -50.0,
            child: GestureDetector(
              onTap: () async {
                pickImage(true);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: _logo == null
                        ? NetworkImage(BASE_URL+profileImg)
                        : FileImage(_logo!) as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                ],
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back button press
          Navigator.pop(context, true); // Returns true to the previous screen
        },
      ),
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
