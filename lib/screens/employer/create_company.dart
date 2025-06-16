import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/services/company/company_api_service.dart';
import 'package:quickhire/widgets/custom_expandable_input_box.dart';
import 'package:quickhire/widgets/custom_input_box.dart';
import 'package:quickhire/widgets/year_picker_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateCompanyProfileScreen extends StatefulWidget {
  const CreateCompanyProfileScreen({super.key});

  @override
  State<CreateCompanyProfileScreen> createState() =>
      _CreateCompanyProfileScreenState();
}

class _CreateCompanyProfileScreenState
    extends State<CreateCompanyProfileScreen> {
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

  CompanyApiService companyApiService = CompanyApiService();

  bool isWorking = false;
  bool _isLoading = false;

  void fetchInitData() {}

  @override
  void initState() {
    super.initState();
  }

  createCompany() {
    int? foundedYear;
    if (foundedYearTextEditingController.text.isNotEmpty) {
      foundedYear = int.tryParse(foundedYearTextEditingController.text);
    }
    Map<String, dynamic> jsonData = {
      'company_name': companyNameTextEditingController.text,
      'company_title': companyTitleTextEditingController.text,
      'company_desc': companyDescTextEditingController.text,
      'company_link': companyLinkTextEditingController.text,
      'linkedin_link': companyLinkedinLinkTextEditingController.text,
      'industry': companyIndustryTextEditingController.text,
      'location': companyLocationTextEditingController.text,
      if (foundedYear != null) 'founded_year': foundedYear.toString(),
    };
    return jsonData;
  }

  _submitCompanyDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool response = await companyApiService.creatCompany(createCompany());

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company created successfully')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/ehome', (route) => false);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create company due to: $error')),
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
      appBar: myCustomAppBar('Add Company Basic Details'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        controller: companyLinkedinLinkTextEditingController,
                        isPassword: false,
                        hasFocus: false,
                      ),
                      headings('Company Industry'),
                      CustomInputBox(
                        hint: 'eg. Software Product',
                        needSvg: false,
                        svgIconPath: 'assets/icons/profile.svg',
                        enabled: true,
                        controller: companyIndustryTextEditingController,
                        isPassword: false,
                        hasFocus: false,
                      ),
                      headings('Company Location'),
                      CustomInputBox(
                        hint: 'Bengaluru, India',
                        needSvg: false,
                        svgIconPath: 'assets/icons/profile.svg',
                        enabled: true,
                        controller: companyLocationTextEditingController,
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
                    onPressed: _isLoading ? null : _submitCompanyDetails,
                    child: _isLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create Company',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: whiteText,
                            ),
                          ),
                  ),
                ),
              ],
            )),
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

  // Widget loadImagePart() {
  //   return Container(
  //     width: double.infinity,
  //     height: 180,
  //     child: Stack(
  //       clipBehavior: Clip.none,
  //       children: [
  //         Container(
  //           width: double.infinity,
  //           height: 180.0,
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: _backgroundImage == null
  //                   ? AssetImage('assets/images/background.jpg')
  //                   : FileImage(_backgroundImage!) as ImageProvider,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 8.0, // Adjust as needed
  //           right: 8.0, // Adjust as needed
  //           child: Container(
  //             height: 40,
  //             width: 40,
  //             decoration: BoxDecoration(
  //               color: primaryColor,
  //               shape: BoxShape.circle,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 2,
  //                   blurRadius: 5,
  //                   offset: const Offset(0, 3),
  //                 ),
  //               ],
  //             ),
  //             child: IconButton(
  //               icon: const Icon(Icons.edit, size: 24, color: whiteText),
  //               onPressed: () async {
  //                 pickImage(false);
  //               },
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           left: 16.0,
  //           bottom: -50.0,
  //           child: GestureDetector(
  //             onTap: () async {
  //               pickImage(true);
  //             },
  //             child: Stack(
  //               clipBehavior: Clip.none,
  //               children: [
  //                 CircleAvatar(
  //                   radius: 50.0,
  //                   backgroundImage: _logo == null
  //                       ? NetworkImage(
  //                           'assets/images/profile_image_placeholder.png')
  //                       : FileImage(_logo!) as ImageProvider,
  //                   backgroundColor: Colors.transparent,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  AppBar myCustomAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
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
