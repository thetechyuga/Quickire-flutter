import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';
import 'package:quickhire/models/company.dart';
import 'package:quickhire/models/job.dart';
import 'package:quickhire/services/company/company_api_service.dart';
import 'package:quickhire/services/job/job_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_expandable_input_box.dart';
import 'package:quickhire/widgets/custom_input_box.dart';

class AddEditJobScreen extends StatefulWidget {
  final Job? job;
  const AddEditJobScreen({super.key, this.job});

  @override
  State<AddEditJobScreen> createState() => _AddEditJobScreenState();
}

class _AddEditJobScreenState extends State<AddEditJobScreen> {
  bool _isLoading = false;

  CompanyApiService companyApiService = CompanyApiService();
  JobApiService jobApiService = JobApiService();

  TextEditingController companyNameTextController = TextEditingController();
  TextEditingController jobRoleTextController = TextEditingController();
  TextEditingController salaryTextController = TextEditingController();
  TextEditingController jobDescTextController = TextEditingController();
  TextEditingController skillsTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String jobType = "Full-Time";
  bool isActive = true;
  late Future<Company> _companyFuture;

  createJob() {
    Map<String, dynamic> jsonData = {
      'role': jobRoleTextController.text,
      'expected_salary': salaryTextController.text,
      'job_type': jobType,
      'job_desc': jobDescTextController.text,
      'skills': skillsTextController.text,
      'is_active': isActive,
    };
    return jsonData;
  }

  emptyDetails() {
    setState(() {
      jobRoleTextController.text = '';
      salaryTextController.text = '';
      jobDescTextController.text = '';
      skillsTextController.text = '';
      isActive = true;
      jobType = "Full-Time";
    });
  }

  deleteJob() async {
    bool isDeleted = false;
    try {
      isDeleted = await jobApiService.deleteJob(widget.job!.jobId);
      debugPrint(isDeleted.toString());

      if (isDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Deleted')),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete job: $error')),
      );
    }
  }

  void confirmDeletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteJob();
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

  Future<void> _submitJobDetails() async {
    bool isPost = widget.job == null;
    bool updateResponse = false;
    bool createResponse = false;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isPost) {
        createResponse = await jobApiService.createJob(createJob());
      } else {
        updateResponse =
            await jobApiService.updateJob(createJob(), widget.job!.jobId);
      }

      if (createResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Posted')),
        );
        emptyDetails();
      }

      if (updateResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isPost
                  ? 'Job posted successfully'
                  : 'Job updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      String errorString = error.toString();
      errorString = errorString.replaceAll('Exception:', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: isPost
                ? Text('Failed to post job details: $errorString')
                : Text('Failed to update job details: $errorString')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  fetchInitData() {
    _companyFuture = companyApiService.fetchCompanyDetails();
    if (widget.job != null) {
      jobRoleTextController.text = widget.job!.role;
      salaryTextController.text = widget.job!.expectedSalary;
      jobDescTextController.text = widget.job!.jobDesc;
      skillsTextController.text = widget.job!.skills;
      jobType = widget.job!.jobType;
      isActive = widget.job!.isActive;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        widget.job == null ? "Post Job" : "Update Job",
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: FutureBuilder<Company>(
              future: _companyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  if (snapshot.error.toString().contains('Company Not found')) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showErrorDialog(
                          'Company not Found',
                          'It seems you dont have a company. Kindly create a company to post jobs',
                          context);
                    });
                    return const SizedBox.shrink();
                  }
                  print("issue is here");
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No user data available.'));
                } else {
                  Company companyData = snapshot.data!;
                  companyNameTextController.text = companyData.companyName;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userImage(companyData.companyLogo),
                      headings('Company Name'),
                      CustomInputBox(
                        needSvg: false,
                        hint: 'company Name',
                        svgIconPath: 'assets/icons/job.svg',
                        enabled: false,
                        controller: companyNameTextController,
                        hasFocus: false,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          right: horizontalPadding,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '*Update company details on the company page.',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: smallFontSize,
                              fontWeight: poppinsRegular,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headings('Job Role'),
                            CustomInputBox(
                              needSvg: false,
                              hint: 'Job role',
                              svgIconPath: 'assets/icons/job.svg',
                              enabled: true,
                              controller: jobRoleTextController,
                              hasFocus: false,
                            ),
                            headings('Job Description'),
                            CustomExpandableInputBox(
                              hint: 'Job Description',
                              enabled: true,
                              controller: jobDescTextController,
                              hasFocus: false,
                            ),
                            headings('Salary Range'),
                            CustomInputBox(
                              needSvg: false,
                              hint: 'e.g. 10L - 20L',
                              svgIconPath: 'assets/icons/job.svg',
                              enabled: true,
                              controller: salaryTextController,
                              hasFocus: false,
                            ),
                            headings('Requried Skills'),
                            CustomInputBox(
                              needSvg: false,
                              hint: 'e.g. Flutter, Dart, Django',
                              svgIconPath: 'assets/icons/job.svg',
                              enabled: true,
                              controller: skillsTextController,
                              hasFocus: false,
                            ),
                            headings('Job Type'),
                            jobTypeWidget(),
                            headings('Job Status'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isActive,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isActive = value ?? true;
                                      });
                                    },
                                  ),
                                  Text(
                                    isActive
                                        ? 'Job is Active'
                                        : 'Job is Inactive',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 44),
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _isLoading ? null : _submitJobDetails,
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
                                  : Text(
                                      widget.job == null
                                          ? 'Add job'
                                          : 'Update Job',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: whiteText,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding jobTypeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Wrap(
        spacing: 8.0,
        children: [
          ChoiceChip(
            label: const Text('Full-Time'),
            selected: jobType == "Full-Time",
            onSelected: (bool selected) {
              setState(() {
                jobType = selected ? 'Full-Time' : jobType;
              });
            },
          ),
          ChoiceChip(
            label: const Text('Part-Time'),
            selected: jobType == 'Part-Time',
            onSelected: (bool selected) {
              setState(() {
                jobType = selected ? 'Part-Time' : jobType;
              });
            },
          ),
          ChoiceChip(
            label: const Text('Remote'),
            selected: jobType == 'Remote',
            onSelected: (bool selected) {
              setState(() {
                jobType = selected ? 'Remote' : jobType;
              });
            },
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

  Center userImage(String companyImage) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundColor: secondaryColor,
        backgroundImage: NetworkImage(BASE_URL + companyImage),
      ),
    );
  }

  AppBar customAppBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      titleTextStyle: const TextStyle(
        color: primaryText,
        fontSize: largeFontSize,
        fontWeight: poppinsSemiBold,
      ),
      actions: widget.job != null
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  confirmDeletionDialog();
                },
              ),
            ]
          : [],
    );
  }
}
