import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/exam_view_model.dart';

class AddExamScreen extends StatefulWidget {
  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortInformationController =
      TextEditingController();
  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController dashboardNameController = TextEditingController();
  final TextEditingController tileNameNameController = TextEditingController();
  final TextEditingController fullNameOfExamController =
      TextEditingController();
  final TextEditingController advertisementNoController =
      TextEditingController();
  final TextEditingController howToPayController = TextEditingController();
  final TextEditingController ageRelaxationBriefController =
      TextEditingController();
  final TextEditingController applyOnlineController = TextEditingController();
  final TextEditingController downloadShortNoticeController =
      TextEditingController();
  final TextEditingController downloadNotificationController =
      TextEditingController();
  final TextEditingController officialWebsiteController =
      TextEditingController();
  final TextEditingController broucherLinkController = TextEditingController();
  final TextEditingController resultlinkController = TextEditingController();
  final TextEditingController howToCheckResultController =
      TextEditingController();
  final TextEditingController howToFillFormController = TextEditingController();
  final TextEditingController howToDownloadAdmitCardController =
      TextEditingController();
  final TextEditingController correctionInFormLinkController =
      TextEditingController();

  // Numeric fields controllers
  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final TextEditingController generalCategoryFeeController =
      TextEditingController();
  final TextEditingController obcCategoryFeeController =
      TextEditingController();
  final TextEditingController ewsCategoryFeeController =
      TextEditingController();
  final TextEditingController scstCategoryFeeController =
      TextEditingController();
  final TextEditingController phCategoryFeeController = TextEditingController();
  final TextEditingController PostnameController = TextEditingController();
  final TextEditingController womenCategoryFeeController =
      TextEditingController();

  List<Map<String, dynamic>> postDetails = [];
  List<Map<String, dynamic>> postControllers = [];

  final TextEditingController postNameController = TextEditingController();
  final TextEditingController totalPostController = TextEditingController();
  final TextEditingController generalPostController = TextEditingController();
  final TextEditingController obcPostController = TextEditingController();
  final TextEditingController ewsPostController = TextEditingController();
  final TextEditingController scPostController = TextEditingController();
  final TextEditingController stPostController = TextEditingController();

  // Date fields
  DateTime? applicationBegin;
  DateTime? lastDateToApply;
  DateTime? lastDateToPayExamFee;
  DateTime? admitCardAvailable;
  DateTime? answerKeyAvailable;
  DateTime? syllabusAvailableDate;
  DateTime? resultPostingDate;
  DateTime? certificateVerificationAvailable;
  DateTime? important;
  DateTime? examDate;
  DateTime? ageFrom;
  DateTime? ageUpto;
  DateTime? admitCardAvailableEdit;
  DateTime? answerKeyAvailableEdit;
  DateTime? resultPostModify;
  DateTime? correctiondateInForm;
  DateTime? jobPostingDate;

  String? selectedCategory;
  String? selectedeligibilityDetails;

  bool isAdmitCardAvailable = false;
  bool isAnswerKeyAvailable = false;
  bool syllabusAvailable = false;
  bool resultAvailable = false;
  bool iscertificateVerificationAvailable = false;
  bool isImportant = false;
  bool multiPost = false;
  bool shortNotice = false;
  bool downloadBroucher = false;
  bool correctionInForm = false;

  // Function to pick a date
  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  // Common Card Wrapper for styling
  Widget _styledCard(Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      color: white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: child,
      ),
    );
  }

  // Styled Date Picker
  Widget _buildDatePicker(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return _styledCard(
      ListTile(
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          selectedDate != null
              ? selectedDate.toLocal().toString().split(' ')[0]
              : "Select a date",
          style: TextStyle(
              fontSize: 16,
              color: selectedDate != null ? Colors.black : Colors.grey),
        ),
        trailing: Icon(Icons.calendar_today, color: Colors.blue),
        onTap: () => _selectDate(context, selectedDate, onDateSelected),
      ),
    );
  }

  // Styled Checkbox with Date Picker
  Widget _buildCheckboxWithDate(
      String label,
      bool value,
      DateTime? selectedDate,
      Function(bool) onChanged,
      Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _styledCard(
          CheckboxListTile(
            title: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            value: value,
            onChanged: (val) => onChanged(val!),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        if (value)
          _buildDatePicker("$label Date", selectedDate, onDateSelected),
      ],
    );
  }

  // Helper: Styled TextField with optional validation
  Widget _buildTextFieldWithValidation(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: white,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "Enter $label";
        }
        if (isNumber && value != null && value.isNotEmpty) {
          final numberRegex = RegExp(r'^\d+$'); // Allows only digits (0-9)
          if (!numberRegex.hasMatch(value)) {
            return "Only numbers are allowed";
          }
        }
        return null; // Validation passed
      },
    );
  }

  Widget TextFieldWithMultiLines(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isRequired = false,
    int maxLines = 1, // Default to single-line input
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
      maxLines: maxLines, // Allows expansion as needed
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: white,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "Enter $label";
        }
        if (isNumber && value != null && value.isNotEmpty) {
          final numberRegex = RegExp(r'^\d+$'); // Allows only digits (0-9)
          if (!numberRegex.hasMatch(value)) {
            return "Only numbers are allowed";
          }
        }
        return null; // Validation passed
      },
    );
  }

  void _addPostField() {
    final eligibilityViewModel =
        Provider.of<EligibilityViewModel>(context, listen: false);

    setState(() {
      postControllers.add({
        "Postname": TextEditingController(),
        "TotalPost": TextEditingController(),
        "GeneralPost": TextEditingController(),
        "OBCPost": TextEditingController(),
        "EWSPost": TextEditingController(),
        "SCPost": TextEditingController(),
        "STPost": TextEditingController(),
        "EligibilityDetails": eligibilityViewModel.eligibilities.isNotEmpty
            ? eligibilityViewModel.eligibilities.first["id"]
            : "", // Ensure it's a non-null value
      });
    });
  }

  void _savePost(int index) {
    print("These is the Podst.........................................");
    if (_formKey.currentState!.validate()) {
      setState(() {
        postDetails.add({
          "postName": postControllers[index]["Postname"]?.text ?? "",
          "totalPost": postControllers[index]["TotalPost"]?.text ?? "",
          "generalPost": postControllers[index]["GeneralPost"]?.text ?? "",
          "obcPost": postControllers[index]["OBCPost"]?.text ?? "",
          "ewsPost": postControllers[index]["EWSPost"]?.text ?? "",
          "scPost": postControllers[index]["SCPost"]?.text ?? "",
          "stPost": postControllers[index]["STPost"]?.text ?? "",
          "eligiblityDetails":
              postControllers[index]["EligibilityDetails"] ?? "",
        });

    print("These is the Podst data.........................................$postDetails");
    print("These is the Podst Length........................................${postDetails.length}");


        print(
            "Saved eligibilityDetails for index $index: ${postControllers[index]["EligibilityDetails"]}");
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post added successfully!")),
      );
    }
  }

  void _deletePost(int index) {
    if (index >= 0 && index < postControllers.length) {
      setState(() {
        postControllers.removeAt(index);
        if (index < postDetails.length) {
          postDetails.removeAt(index); // Keep both lists in sync
        }
      });

      print("✅ Deleted post at index $index");
    } else {
      print("❌ Error: Cannot delete at invalid index $index");
    }
  }

  int? parseNullableInt(String text) {
    return text.trim().isEmpty ? null : int.tryParse(text);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;
    final GlobalKey<FormState> _mobileFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> _desktopFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluegray,
        title: Center(
          child: Text(
            "Add Exam",
            style: TextStyle(color: white),
          ),
        ),
      ),
      drawer: isDesktop
          ? null
          : CustomDrawer(
              onLogout: () => authViewModel.logout(),
            ),
      body: Container(
        color: bluegray50,
        child: Row(
          children: [
            // Drawer for desktop
            isDesktop
                ? CustomDrawer(
                    onLogout: () => authViewModel.logout(),
                  )
                : SizedBox(),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isDesktop
                        ? buildDesktopView(
                            formKey:
                                _desktopFormKey) // ✅ Correct form key for desktop
                        : buildMobileView(
                            formKey:
                                _mobileFormKey), // ✅ Correct form key for mobile
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopView({
    required GlobalKey<FormState> formKey,
  }) {
    final examViewModel = Provider.of<ExamViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    return Form(
      key: formKey, // ✅ Use correct unique key
      child: Column(
        children: [
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextFieldWithValidation(nameController, "Exam Name",
                      isRequired: true),
                  SizedBox(height: 20),
                  TextFieldWithMultiLines(
                      shortInformationController, "Short Information",
                      maxLines: 5),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      organizationNameController, "Organization Name"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            dashboardNameController, "Dashboard Name"),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            tileNameNameController, "Tile Name"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      fullNameOfExamController, "Full Name Of Exam"),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            generalCategoryFeeController,
                            "General Category Fee",
                            isNumber: true),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            obcCategoryFeeController, "OBC Category Fee",
                            isNumber: true),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            ewsCategoryFeeController, "EWS Category Fee",
                            isNumber: true),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            scstCategoryFeeController, "SC/ST Category Fee",
                            isNumber: true),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            phCategoryFeeController, "PH Category Fee",
                            isNumber: true),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithValidation(
                            womenCategoryFeeController, "Women Category Fee",
                            isNumber: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    TextFieldWithMultiLines(
                        howToFillFormController, "How To Fill Form",
                        maxLines: 3),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithValidation(
                              minAgeController, "Min Age",
                              isNumber: true),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFieldWithValidation(
                              maxAgeController, "Max Age",
                              isNumber: true),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(howToPayController, "How To Pay",
                        maxLines: 3),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(
                        howToCheckResultController, "How To Check Result",
                        maxLines: 3),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(howToDownloadAdmitCardController,
                        "How To Download Admit Card",
                        maxLines: 3),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        correctionInFormLinkController,
                        "Correction In Form Link"),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _buildTextFieldWithValidation(
                        applyOnlineController, "Apply Online"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithValidation(
                              advertisementNoController, "Advertisement No"),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFieldWithValidation(
                              officialWebsiteController, "Official Website"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithValidation(
                              broucherLinkController, "Broucher Link"),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFieldWithValidation(
                              resultlinkController, "Result Link"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(
                        downloadShortNoticeController, "Download Short Notice",
                        maxLines: 2),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        downloadNotificationController,
                        "Download Notification"),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        ageRelaxationBriefController, "Age Relaxation Brief"),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                              "Application Begin",
                              applicationBegin,
                              (date) =>
                                  setState(() => applicationBegin = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker(
                              "Last Date To Apply",
                              lastDateToApply,
                              (date) => setState(() => lastDateToApply = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker("Exam Date", examDate,
                              (date) => setState(() => examDate = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker(
                              "Last Date To Pay Exam Fee",
                              lastDateToPayExamFee,
                              (date) =>
                                  setState(() => lastDateToPayExamFee = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker("Age From", ageFrom,
                              (date) => setState(() => ageFrom = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker("Age Upto", ageUpto,
                              (date) => setState(() => ageUpto = date)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCheckboxWithDate(
                              "Admit Card Available",
                              isAdmitCardAvailable,
                              admitCardAvailable,
                              (val) =>
                                  setState(() => isAdmitCardAvailable = val),
                              (date) =>
                                  setState(() => admitCardAvailable = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildCheckboxWithDate(
                              "Syllabus Available",
                              syllabusAvailable,
                              syllabusAvailableDate,
                              (val) => setState(() => syllabusAvailable = val),
                              (date) =>
                                  setState(() => syllabusAvailableDate = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCheckboxWithDate(
                              "Answer Key Available",
                              isAnswerKeyAvailable,
                              answerKeyAvailable,
                              (val) =>
                                  setState(() => isAnswerKeyAvailable = val),
                              (date) =>
                                  setState(() => answerKeyAvailable = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildCheckboxWithDate(
                              "Result Available",
                              resultAvailable,
                              resultPostingDate,
                              (val) => setState(() => resultAvailable = val),
                              (date) =>
                                  setState(() => resultPostingDate = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCheckboxWithDate(
                              "certificateVerification Available",
                              iscertificateVerificationAvailable,
                              certificateVerificationAvailable,
                              (val) => setState(() =>
                                  iscertificateVerificationAvailable = val),
                              (date) => setState(() =>
                                  certificateVerificationAvailable = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildCheckboxWithDate(
                              "Important Available",
                              isImportant,
                              important,
                              (val) => setState(() => isImportant = val),
                              (date) => setState(() => important = date)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                              "Admit Card Available Edit",
                              admitCardAvailableEdit,
                              (date) => setState(
                                  () => admitCardAvailableEdit = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker(
                              "Answer Key Available Edit",
                              answerKeyAvailableEdit,
                              (date) => setState(
                                  () => answerKeyAvailableEdit = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                              "Result Post Modify",
                              resultPostModify,
                              (date) =>
                                  setState(() => resultPostModify = date)),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDatePicker(
                              "Correction Date In Form",
                              correctiondateInForm,
                              (date) =>
                                  setState(() => correctiondateInForm = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                              "Job Posting Date",
                              jobPostingDate,
                              (date) => setState(() => jobPostingDate = date)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _styledCard(
                            CheckboxListTile(
                              title: Text("Multi Post",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              value: multiPost,
                              onChanged: (val) =>
                                  setState(() => multiPost = val!),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _styledCard(
                            CheckboxListTile(
                              title: Text("Short Notice",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              value: shortNotice,
                              onChanged: (val) =>
                                  setState(() => shortNotice = val!),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _styledCard(
                            CheckboxListTile(
                              title: Text("Download Broucher",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              value: downloadBroucher,
                              onChanged: (val) =>
                                  setState(() => downloadBroucher = val!),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _styledCard(
                            CheckboxListTile(
                              title: Text("Correction In Form",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              value: correctionInForm,
                              onChanged: (val) =>
                                  setState(() => correctionInForm = val!),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _styledCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  hintText: "Select Category",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: white,
                                ),
                                value: selectedCategory,
                                items: categoryViewModel.categories
                                    .map((category) => DropdownMenuItem(
                                          value: category["id"] as String,
                                          child: Text(
                                            category["name"] as String,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                  print("Selected Category: $selectedCategory");
                                },
                                validator: (value) => value == null
                                    ? "Please select a category"
                                    : null, // Validation
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ...List.generate(postControllers.length, (index) {
                      if (postControllers.isEmpty ||
                          postControllers[index] == null) {
                        return SizedBox(); // Return an empty widget if no data exists
                      }
                      return _styledCard(
                        Column(
                          children: [
                            _buildTextFieldWithValidation(
                                postControllers[index]["Postname"] ??
                                    TextEditingController(),
                                "Post Name",
                                isRequired: true),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFieldWithValidation(
                                      postControllers[index]["TotalPost"]!,
                                      "Total Post",
                                      isNumber: true),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextFieldWithValidation(
                                      postControllers[index]["GeneralPost"]!,
                                      "General Post",
                                      isNumber: true),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFieldWithValidation(
                                      postControllers[index]["OBCPost"]!,
                                      "OBC Post",
                                      isNumber: true),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextFieldWithValidation(
                                      postControllers[index]["EWSPost"]!,
                                      "EWS Post",
                                      isNumber: true),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFieldWithValidation(
                                      postControllers[index]["SCPost"]!,
                                      "SC Post",
                                      isNumber: true),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextFieldWithValidation(
                                      postControllers[index]["STPost"]!,
                                      "ST Post",
                                      isNumber: true),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "Select Eligibility Details",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: white,
                              ),
                              value: postControllers[index]
                                      ["EligibilityDetails"] ??
                                  "", // Ensure it's not null
                              items: eligibilityViewModel.eligibilities
                                  .map((eligibility) {
                                return DropdownMenuItem(
                                  value: eligibility["id"] as String,
                                  child: Text(eligibility["name"] as String),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  postControllers[index]["EligibilityDetails"] =
                                      value ?? "";
                                });
                              },
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Please select eligibility"
                                      : null,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _deletePost(index);
                                  },
                                  child: Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addPostField,
                      child: Text("+ Add Posts"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              print("Buttpn Press....................00");
              if (formKey.currentState!.validate()) {
                for (int i = 0; i < postControllers.length; i++) {
                  _savePost(i);
                }
                Map<String, dynamic> newExam = {
                  "name": nameController.text,
                  "examCategory": selectedCategory,
                  "postDate": DateTime.now().toIso8601String(),
                  "shortInformation": shortInformationController.text,
                  "DashboardName": dashboardNameController.text,
                  "tileName": tileNameNameController.text,
                  "organizationName": organizationNameController.text,
                  "fullNameOfExam": fullNameOfExamController.text,
                  "advertisementNo": advertisementNoController.text,
                  "applicationBegin": applicationBegin?.toIso8601String(),
                  "lastDateToApply": lastDateToApply?.toIso8601String(),
                  "lastDateToPayExamFee":
                      lastDateToPayExamFee?.toIso8601String(),
                  "examDate": examDate?.toIso8601String(),
                  "isadmitCardAvailable": isAdmitCardAvailable,
                  "admitCardAvailable": admitCardAvailable?.toIso8601String(),
                  "admitCardAvailableEdit":
                      admitCardAvailableEdit?.toIso8601String(),
                  "isanswerKeyAvailable": isAnswerKeyAvailable,
                  "answerKeyAvailable": answerKeyAvailable?.toIso8601String(),
                  "answerKeyAvailableEdit":
                      answerKeyAvailableEdit?.toIso8601String(),
                  "iscertificateVerificationAvailable":
                      iscertificateVerificationAvailable,
                  "certificateVerificationAvailable":
                      certificateVerificationAvailable?.toIso8601String(),
                  "isImportant": isImportant,
                  "important": important?.toIso8601String(),
                  "generalCategoryFee":
                      parseNullableInt(generalCategoryFeeController.text),
                  "obcCategoryFee":
                      parseNullableInt(obcCategoryFeeController.text),
                  "ewsCategoryFee":
                      parseNullableInt(ewsCategoryFeeController.text),
                  "scstCategoryFee":
                      parseNullableInt(scstCategoryFeeController.text),
                  "phCategoryFee":
                      parseNullableInt(phCategoryFeeController.text),
                  "womenCategoryFee":
                      parseNullableInt(womenCategoryFeeController.text),
                  "howToPay": howToPayController.text,
                  "minAge": parseNullableInt(minAgeController.text),
                  "maxAge": parseNullableInt(maxAgeController.text),
                  "ageRelaxationBrief": ageRelaxationBriefController.text,
                  "ageFrom": ageFrom?.toIso8601String(),
                  "ageUpto": ageUpto?.toIso8601String(),
                  "multiPost": multiPost,
                  "postDetails": postDetails, // Storing multiple posts
                  "applyOnline": applyOnlineController.text,
                  "shortNotice": shortNotice,
                  "downloadShortNotice": downloadShortNoticeController.text,
                  "downloadNotification": downloadNotificationController.text,
                  "officialWebsite": officialWebsiteController.text,
                  "downloadBroucher": downloadBroucher,
                  "broucherLink": broucherLinkController.text,
                  "syllabusAvailable": syllabusAvailable,
                  "syllabusAvailableDate":
                      syllabusAvailableDate?.toIso8601String(),
                  "resultAvailable": resultAvailable,
                  "resultPostingDate": resultPostingDate?.toIso8601String(),
                  "resultPostModify": resultPostModify?.toIso8601String(),
                  "resultlink": resultlinkController.text,
                  "howToCheckResult": howToCheckResultController.text,
                  "howToFillForm": howToFillFormController.text,
                  "howToDownloadAdmitCard":
                      howToDownloadAdmitCardController.text,
                  "correctionInForm": correctionInForm,
                  "correctionInFormLink": correctionInFormLinkController.text,
                  "correctiondateInForm":
                      correctiondateInForm?.toIso8601String(),
                  "jobPostingDate": jobPostingDate?.toIso8601String(),
                };
                print("These is the exam .................................................$newExam");
                await examViewModel.addExam(newExam);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Exam added successfully!")),
                );

                context.go('/exams');
              }
            },
            child: Text("Add Exam"),
          ),
        ],
      ),
    );
  }

  Widget buildMobileView({
    required GlobalKey<FormState> formKey, // Use a separate form key
  }) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final examViewModel = Provider.of<ExamViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    return Form(
      key: formKey, // ✅ Use correct unique key
      child: Column(
        children: [
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextFieldWithValidation(nameController, "Exam Name",
                      isRequired: true),
                  SizedBox(height: 20),
                  TextFieldWithMultiLines(
                      shortInformationController, "Short Information",
                      maxLines: 5),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      organizationNameController, "Organization Name"),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      dashboardNameController, "Dashboard Name"),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      tileNameNameController, "Tile Name"),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      fullNameOfExamController, "Full Name Of Exam"),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextFieldWithValidation(
                      generalCategoryFeeController, "General Category Fee",
                      isNumber: true),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      obcCategoryFeeController, "OBC Category Fee",
                      isNumber: true),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      ewsCategoryFeeController, "EWS Category Fee",
                      isNumber: true),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      scstCategoryFeeController, "SC/ST Category Fee",
                      isNumber: true),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      phCategoryFeeController, "PH Category Fee",
                      isNumber: true),
                  SizedBox(height: 20),
                  _buildTextFieldWithValidation(
                      womenCategoryFeeController, "Women Category Fee",
                      isNumber: true),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    TextFieldWithMultiLines(
                        howToFillFormController, "How To Fill Form",
                        maxLines: 3),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(minAgeController, "Min Age",
                        isNumber: true),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(maxAgeController, "Max Age",
                        isNumber: true),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(howToPayController, "How To Pay",
                        maxLines: 3),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(
                        howToCheckResultController, "How To Check Result",
                        maxLines: 3),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(howToDownloadAdmitCardController,
                        "How To Download Admit Card",
                        maxLines: 3),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        correctionInFormLinkController,
                        "Correction In Form Link"),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _buildTextFieldWithValidation(
                        applyOnlineController, "Apply Online"),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        advertisementNoController, "Advertisement No"),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        officialWebsiteController, "Official Website"),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        broucherLinkController, "Broucher Link"),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        resultlinkController, "Result Link"),
                    SizedBox(height: 20),
                    TextFieldWithMultiLines(
                        downloadShortNoticeController, "Download Short Notice",
                        maxLines: 2),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        downloadNotificationController,
                        "Download Notification"),
                    SizedBox(height: 20),
                    _buildTextFieldWithValidation(
                        ageRelaxationBriefController, "Age Relaxation Brief"),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _buildDatePicker("Application Begin", applicationBegin,
                        (date) => setState(() => applicationBegin = date)),
                    SizedBox(height: 20),
                    _buildDatePicker("Last Date To Apply", lastDateToApply,
                        (date) => setState(() => lastDateToApply = date)),
                    SizedBox(height: 20),
                    _buildDatePicker("Exam Date", examDate,
                        (date) => setState(() => examDate = date)),
                    SizedBox(height: 20),
                    _buildDatePicker(
                        "Last Date To Pay Exam Fee",
                        lastDateToPayExamFee,
                        (date) => setState(() => lastDateToPayExamFee = date)),
                    SizedBox(height: 20),
                    _buildDatePicker("Age From", ageFrom,
                        (date) => setState(() => ageFrom = date)),
                    SizedBox(height: 20),
                    _buildDatePicker("Age Upto", ageUpto,
                        (date) => setState(() => ageUpto = date)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _buildCheckboxWithDate(
                        "Admit Card Available",
                        isAdmitCardAvailable,
                        admitCardAvailable,
                        (val) => setState(() => isAdmitCardAvailable = val),
                        (date) => setState(() => admitCardAvailable = date)),
                    SizedBox(height: 20),
                    _buildCheckboxWithDate(
                        "Syllabus Available",
                        syllabusAvailable,
                        syllabusAvailableDate,
                        (val) => setState(() => syllabusAvailable = val),
                        (date) => setState(() => syllabusAvailableDate = date)),
                    SizedBox(height: 20),
                    _buildCheckboxWithDate(
                        "Answer Key Available",
                        isAnswerKeyAvailable,
                        answerKeyAvailable,
                        (val) => setState(() => isAnswerKeyAvailable = val),
                        (date) => setState(() => answerKeyAvailable = date)),
                    SizedBox(height: 20),
                    _buildCheckboxWithDate(
                        "Result Available",
                        resultAvailable,
                        resultPostingDate,
                        (val) => setState(() => resultAvailable = val),
                        (date) => setState(() => resultPostingDate = date)),
                    SizedBox(height: 20),
                    _buildCheckboxWithDate(
                        "certificateVerification Available",
                        iscertificateVerificationAvailable,
                        certificateVerificationAvailable,
                        (val) => setState(
                            () => iscertificateVerificationAvailable = val),
                        (date) => setState(
                            () => certificateVerificationAvailable = date)),
                    SizedBox(height: 20),
                    _buildCheckboxWithDate(
                        "Important Available",
                        isImportant,
                        important,
                        (val) => setState(() => isImportant = val),
                        (date) => setState(() => important = date)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _buildDatePicker(
                        "Admit Card Available Edit",
                        admitCardAvailableEdit,
                        (date) =>
                            setState(() => admitCardAvailableEdit = date)),
                    SizedBox(height: 20),
                    _buildDatePicker(
                        "Answer Key Available Edit",
                        answerKeyAvailableEdit,
                        (date) =>
                            setState(() => answerKeyAvailableEdit = date)),
                    SizedBox(height: 20),
                    _buildDatePicker("Result Post Modify", resultPostModify,
                        (date) => setState(() => resultPostModify = date)),
                    SizedBox(height: 20),
                    _buildDatePicker(
                        "Correction Date In Form",
                        correctiondateInForm,
                        (date) => setState(() => correctiondateInForm = date)),
                    SizedBox(height: 20),
                    _buildDatePicker("Job Posting Date", jobPostingDate,
                        (date) => setState(() => jobPostingDate = date)),
                    SizedBox(height: 20),
                    _styledCard(
                      CheckboxListTile(
                        title: Text("Multi Post",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        value: multiPost,
                        onChanged: (val) => setState(() => multiPost = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    SizedBox(height: 20),
                    _styledCard(
                      CheckboxListTile(
                        title: Text("Short Notice",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        value: shortNotice,
                        onChanged: (val) => setState(() => shortNotice = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    SizedBox(height: 20),
                    _styledCard(
                      CheckboxListTile(
                        title: Text("Download Broucher",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        value: downloadBroucher,
                        onChanged: (val) =>
                            setState(() => downloadBroucher = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    SizedBox(height: 20),
                    _styledCard(
                      CheckboxListTile(
                        title: Text("Correction In Form",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        value: correctionInForm,
                        onChanged: (val) =>
                            setState(() => correctionInForm = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    _styledCard(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  hintText: "Select Category",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: white,
                                ),
                                value: selectedCategory,
                                items: categoryViewModel.categories
                                    .map((category) => DropdownMenuItem(
                                          value: category["id"] as String,
                                          child: Text(
                                            category["name"] as String,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                  print("Selected Category: $selectedCategory");
                                },
                                validator: (value) => value == null
                                    ? "Please select a category"
                                    : null, // Validation
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ...List.generate(postControllers.length, (index) {
                      if (postControllers.isEmpty ||
                          postControllers[index] == null) {
                        return SizedBox(); // Return an empty widget if no data exists
                      }
                      return _styledCard(
                        Column(
                          children: [
                            _buildTextFieldWithValidation(
                                postControllers[index]["Postname"] ??
                                    TextEditingController(),
                                "Post Name",
                                isRequired: true),
                            SizedBox(height: 20),
                            _buildTextFieldWithValidation(
                                postControllers[index]["TotalPost"]!,
                                "Total Post",
                                isNumber: true),
                            SizedBox(height: 20),
                            _buildTextFieldWithValidation(
                                postControllers[index]["GeneralPost"]!,
                                "General Post",
                                isNumber: true),
                            SizedBox(height: 20),
                            _buildTextFieldWithValidation(
                                postControllers[index]["OBCPost"]!, "OBC Post",
                                isNumber: true),
                            SizedBox(height: 20),
                            _buildTextFieldWithValidation(
                                postControllers[index]["EWSPost"]!, "EWS Post",
                                isNumber: true),
                            SizedBox(height: 20),
                            _buildTextFieldWithValidation(
                                postControllers[index]["SCPost"]!, "SC Post",
                                isNumber: true),
                            SizedBox(height: 20),
                            _buildTextFieldWithValidation(
                                postControllers[index]["STPost"]!, "ST Post",
                                isNumber: true),
                            SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: "Select Eligibility Details",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: white,
                              ),
                              value: postControllers[index]
                                      ["EligibilityDetails"] ??
                                  "", // Ensure it's not null
                              items: eligibilityViewModel.eligibilities
                                  .map((eligibility) {
                                return DropdownMenuItem(
                                  value: eligibility["id"] as String,
                                  child: Text(eligibility["name"] as String),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  postControllers[index]["EligibilityDetails"] =
                                      value ?? "";
                                });
                              },
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Please select eligibility"
                                      : null,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _deletePost(index);
                              },
                              child: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addPostField,
                      child: Text("+ Add Posts"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                for (int i = 0; i < postControllers.length; i++) {
                  _savePost(i);
                }
                Map<String, dynamic> newExam = {
                  "name": nameController.text,
                  "examCategory": selectedCategory,
                  "postDate": DateTime.now().toIso8601String(),
                  "shortInformation": shortInformationController.text,
                  "DashboardName": dashboardNameController.text,
                  "tileName": tileNameNameController.text,
                  "organizationName": organizationNameController.text,
                  "fullNameOfExam": fullNameOfExamController.text,
                  "advertisementNo": advertisementNoController.text,
                  "applicationBegin": applicationBegin?.toIso8601String(),
                  "lastDateToApply": lastDateToApply?.toIso8601String(),
                  "lastDateToPayExamFee":
                      lastDateToPayExamFee?.toIso8601String(),
                  "examDate": examDate?.toIso8601String(),
                  "isadmitCardAvailable": isAdmitCardAvailable,
                  "admitCardAvailable": admitCardAvailable?.toIso8601String(),
                  "admitCardAvailableEdit":
                      admitCardAvailableEdit?.toIso8601String(),
                  "isanswerKeyAvailable": isAnswerKeyAvailable,
                  "answerKeyAvailable": answerKeyAvailable?.toIso8601String(),
                  "answerKeyAvailableEdit":
                      answerKeyAvailableEdit?.toIso8601String(),
                  "iscertificateVerificationAvailable":
                      iscertificateVerificationAvailable,
                  "certificateVerificationAvailable":
                      certificateVerificationAvailable?.toIso8601String(),
                  "isImportant": isImportant,
                  "important": important?.toIso8601String(),
                  "generalCategoryFee":
                      parseNullableInt(generalCategoryFeeController.text),
                  "obcCategoryFee":
                      parseNullableInt(obcCategoryFeeController.text),
                  "ewsCategoryFee":
                      parseNullableInt(ewsCategoryFeeController.text),
                  "scstCategoryFee":
                      parseNullableInt(scstCategoryFeeController.text),
                  "phCategoryFee":
                      parseNullableInt(phCategoryFeeController.text),
                  "womenCategoryFee":
                      parseNullableInt(womenCategoryFeeController.text),
                  "howToPay": howToPayController.text,
                  "minAge": parseNullableInt(minAgeController.text),
                  "maxAge": parseNullableInt(maxAgeController.text),
                  "ageRelaxationBrief": ageRelaxationBriefController.text,
                  "ageFrom": ageFrom?.toIso8601String(),
                  "ageUpto": ageUpto?.toIso8601String(),
                  "multiPost": multiPost,
                  "postDetails": postDetails, // Storing multiple posts
                  "applyOnline": applyOnlineController.text,
                  "shortNotice": shortNotice,
                  "downloadShortNotice": downloadShortNoticeController.text,
                  "downloadNotification": downloadNotificationController.text,
                  "officialWebsite": officialWebsiteController.text,
                  "downloadBroucher": downloadBroucher,
                  "broucherLink": broucherLinkController.text,
                  "syllabusAvailable": syllabusAvailable,
                  "syllabusAvailableDate":
                      syllabusAvailableDate?.toIso8601String(),
                  "resultAvailable": resultAvailable,
                  "resultPostingDate": resultPostingDate?.toIso8601String(),
                  "resultPostModify": resultPostModify?.toIso8601String(),
                  "resultlink": resultlinkController.text,
                  "howToCheckResult": howToCheckResultController.text,
                  "howToFillForm": howToFillFormController.text,
                  "howToDownloadAdmitCard":
                      howToDownloadAdmitCardController.text,
                  "correctionInForm": correctionInForm,
                  "correctionInFormLink": correctionInFormLinkController.text,
                  "correctiondateInForm":
                      correctiondateInForm?.toIso8601String(),
                  "jobPostingDate": jobPostingDate?.toIso8601String(),
                };

                await examViewModel.addExam(newExam);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Exam added successfully!")),
                );

                context.go('/exams');
              }
            },
            child: Text("Add Exam"),
          ),
        ],
      ),
    );
  }

  Widget buildDateField(
      String title, DateTime? date, Function(DateTime) onSelect) {
    return ListTile(
      title: Text("$title: ${date?.toLocal().toString().split(' ')[0] ?? ''}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () => _selectDate(context, date, onSelect),
    );
  }

  Widget buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number);
  }

  Widget buildCheckboxField(
      String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
        title: Text(title), value: value, onChanged: onChanged);
  }
}
