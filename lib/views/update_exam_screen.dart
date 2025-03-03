import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/exam_view_model.dart';

class UpdateExamScreen extends StatefulWidget {
  final String examName;
  final String id;
  final String categoryid;
  final String postid;
  final String eligibilityid;

  UpdateExamScreen(
      {required this.examName,
      required this.id,
      required this.categoryid,
      required this.postid,
      required this.eligibilityid});

  @override
  _UpdateExamScreenState createState() => _UpdateExamScreenState();
}

class _UpdateExamScreenState extends State<UpdateExamScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> postDetails = [];
  List<Map<String, TextEditingController>> postControllers = [];

  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController shortInformationController =
      TextEditingController();
  late TextEditingController organizationNameController =
      TextEditingController();
  late TextEditingController dashboardNameController = TextEditingController();
  late TextEditingController tileNameNameController = TextEditingController();
  late TextEditingController fullNameOfExamController = TextEditingController();
  late TextEditingController advertisementNoController =
      TextEditingController();
  late TextEditingController howToPayController = TextEditingController();
  late TextEditingController ageRelaxationBriefController =
      TextEditingController();
  late TextEditingController applyOnlineController = TextEditingController();
  late TextEditingController downloadShortNoticeController =
      TextEditingController();
  late TextEditingController downloadNotificationController =
      TextEditingController();
  late TextEditingController officialWebsiteController =
      TextEditingController();
  late TextEditingController broucherLinkController = TextEditingController();
  late TextEditingController resultlinkController = TextEditingController();
  late TextEditingController howToCheckResultController =
      TextEditingController();
  late TextEditingController howToFillFormController = TextEditingController();
  late TextEditingController howToDownloadAdmitCardController =
      TextEditingController();
  late TextEditingController correctionInFormLinkController =
      TextEditingController();

  // Numeric fields controllers
  late TextEditingController minAgeController;
  late TextEditingController maxAgeController;
  late TextEditingController generalCategoryFeeController;
  late TextEditingController obcCategoryFeeController;
  late TextEditingController ewsCategoryFeeController;
  late TextEditingController scstCategoryFeeController;
  late TextEditingController phCategoryFeeController;
  late TextEditingController PostnameController = TextEditingController();
  late TextEditingController womenCategoryFeeController =
      TextEditingController();

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

  // Selected category id and name
  String? selectedCategory;
  String? selectedPost;
  String? selectedeligibilityDetails;
  String? selectedCategoryName;
  String? selectedPostName;
  String? selectedEligibilityDetailsName;

  bool isadmitCardAvailable = false;
  bool isanswerKeyAvailable = false;
  bool syllabusAvailable = false;
  bool resultAvailable = false;
  bool iscertificateVerificationAvailable = false;
  bool isImportant = false;
  bool multiPost = false;
  bool shortNotice = false;
  bool downloadBroucher = false;
  bool correctionInForm = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    intializedData();
  }

  Future<void> intializedData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await fetchCategoryData();
      await fetchPostData();
      await fetchEligibilityData();
      await fetchExamData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Initialization error: $e");
    }
  }

  // Fetch category data by widget.categoryid and store its name.
  Future<void> fetchCategoryData() async {
    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);
    final category =
        await categoryViewModel.fetchCategoryById(widget.categoryid);
    // Expecting category to be a map with "categoryName" key.
    if (category != null) {
      setState(() {
        selectedCategoryName = category["categoryName"]?.toString() ?? '';
      });
      print("Selected Category: $selectedCategoryName");
    } else {
      print("No category found for id: ${widget.categoryid}");
    }
  }

  // Fetch post data by widget.postid and store its name.
  Future<void> fetchPostData() async {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    final post = await postViewModel.fetchPostById(widget.postid);
    // Expecting category to be a map with "categoryName" key.
    if (post != null) {
      setState(() {
        selectedPostName = post["postName"]?.toString() ?? '';
      });
      print("Selected post: $selectedPostName");
    } else {
      print("No category found for id: ${widget.postid}");
    }
  }

  // Fetch category data by widget.categoryid and store its name.
  Future<void> fetchEligibilityData() async {
    final eligibilityViewModel =
        Provider.of<EligibilityViewModel>(context, listen: false);
    final eligibility =
        await eligibilityViewModel.fetchEligibilityById(widget.eligibilityid);
    // Expecting category to be a map with "categoryName" key.
    if (eligibility != null) {
      setState(() {
        selectedEligibilityDetailsName =
            eligibility["eligiblityCriteria"]?.toString() ?? '';
      });
      print("Selected eligibility: $selectedEligibilityDetailsName");
    } else {
      print("No eligibility found for id: ${widget.eligibilityid}");
    }
  }

  // Fetch exam details by name and store selected category name from exam data if available.
  Future<void> fetchExamData() async {
    final examViewModel = Provider.of<ExamViewModel>(context, listen: false);
    await examViewModel.fetchExamByName(widget.examName);
    final exam = examViewModel.selectedExam;

    if (exam != null) {
      setState(() {
        nameController = TextEditingController(text: exam["name"]);
        // If exam contains examCategory, extract its _id (if it is a map) or use the value directly.
        if (exam["examCategory"] != null) {
          selectedCategory = exam["examCategory"] is Map
              ? exam["examCategory"]["_id"].toString()
              : exam["examCategory"].toString();
          // Optionally, if exam data contains category name (for instance, exam["categoryName"]), use that:
          if (exam["categoryName"] != null) {
            selectedCategoryName = exam["categoryName"].toString();
          }
        }

        if (exam["postDetails"] != null) {
          postDetails = List<Map<String, dynamic>>.from(exam["postDetails"]);
          postControllers = postDetails.map((post) {
            return {
              "Postname": TextEditingController(text: post["postName"]),
              "TotalPost": TextEditingController(
                  text: post["totalPost"]?.toString() ?? ''),
              "GeneralPost": TextEditingController(
                  text: post["generalPost"]?.toString() ?? ''),
              "OBCPost": TextEditingController(
                  text: post["obcPost"]?.toString() ?? ''),
              "EWSPost": TextEditingController(
                  text: post["ewsPost"]?.toString() ?? ''),
              "SCPost":
                  TextEditingController(text: post["scPost"]?.toString() ?? ''),
              "STPost":
                  TextEditingController(text: post["stPost"]?.toString() ?? ''),
              "eligibilityDetails":
                  TextEditingController(text: post["eligibilityDetails"] ?? ''),
            };
          }).toList();
        }

        if (exam["eligibilityCriteria"] != null) {
          selectedeligibilityDetails = exam["eligibilityCriteria"] is Map
              ? exam["eligibilityCriteria"]["_id"].toString()
              : exam["eligibilityCriteria"].toString();
          // Optionally, if exam data contains category name (for instance, exam["categoryName"]), use that:
          if (exam["eligiblityCriteria"] != null) {
            selectedEligibilityDetailsName =
                exam["eligiblityCriteria"].toString();
          }
        }

        shortInformationController = TextEditingController(
            text: exam["shortInformation"]?.toString() ?? '');
        organizationNameController = TextEditingController(
            text: exam["organizationName"]?.toString() ?? '');
        dashboardNameController = TextEditingController(
            text: exam["DashboardName"]?.toString() ?? '');
        tileNameNameController =
            TextEditingController(text: exam["tileName"]?.toString() ?? '');
        fullNameOfExamController = TextEditingController(
            text: exam["fullNameOfExam"]?.toString() ?? '');
        advertisementNoController = TextEditingController(
            text: exam["advertisementNo"]?.toString() ?? '');
        howToPayController =
            TextEditingController(text: exam["howToPay"]?.toString() ?? '');
        ageRelaxationBriefController = TextEditingController(
            text: exam["ageRelaxationBrief"]?.toString() ?? '');
        applyOnlineController =
            TextEditingController(text: exam["applyOnline"]?.toString() ?? '');
        downloadShortNoticeController = TextEditingController(
            text: exam["downloadShortNotice"]?.toString() ?? '');
        downloadNotificationController = TextEditingController(
            text: exam["downloadNotification"]?.toString() ?? '');
        officialWebsiteController = TextEditingController(
            text: exam["officialWebsite"]?.toString() ?? '');
        broucherLinkController =
            TextEditingController(text: exam["broucherLink"]?.toString() ?? '');
        resultlinkController =
            TextEditingController(text: exam["resultlink"]?.toString() ?? '');
        howToCheckResultController = TextEditingController(
            text: exam["howToCheckResult"]?.toString() ?? '');
        howToFillFormController = TextEditingController(
            text: exam["howToFillForm"]?.toString() ?? '');
        howToDownloadAdmitCardController = TextEditingController(
            text: exam["howToDownloadAdmitCard"]?.toString() ?? '');
        correctionInFormLinkController = TextEditingController(
            text: exam["correctionInFormLink"]?.toString() ?? '');
        PostnameController =
            TextEditingController(text: exam["Postname"]?.toString() ?? '');

        minAgeController =
            TextEditingController(text: exam["minAge"]?.toString() ?? '');
        maxAgeController =
            TextEditingController(text: exam["maxAge"]?.toString() ?? '');
        generalCategoryFeeController = TextEditingController(
            text: exam["generalCategoryFee"]?.toString() ?? '');
        obcCategoryFeeController = TextEditingController(
            text: exam["obcCategoryFee"]?.toString() ?? '');
        ewsCategoryFeeController = TextEditingController(
            text: exam["ewsCategoryFee"]?.toString() ?? '');
        scstCategoryFeeController = TextEditingController(
            text: exam["scstCategoryFee"]?.toString() ?? '');
        phCategoryFeeController = TextEditingController(
            text: exam["phCategoryFee"]?.toString() ?? '');

        applicationBegin = exam["applicationBegin"] != null
            ? DateTime.parse(exam["applicationBegin"])
            : null;
        lastDateToApply = exam["lastDateToApply"] != null
            ? DateTime.parse(exam["lastDateToApply"])
            : null;
        lastDateToPayExamFee = exam["lastDateToPayExamFee"] != null
            ? DateTime.parse(exam["lastDateToPayExamFee"])
            : null;
        admitCardAvailable = exam["admitCardAvailable"] != null
            ? DateTime.parse(exam["admitCardAvailable"])
            : null;
        answerKeyAvailable = exam["answerKeyAvailable"] != null
            ? DateTime.parse(exam["answerKeyAvailable"])
            : null;
        syllabusAvailableDate = exam["syllabusAvailableDate"] != null
            ? DateTime.parse(exam["syllabusAvailableDate"])
            : null;
        resultPostingDate = exam["resultPostingDate"] != null
            ? DateTime.parse(exam["resultPostingDate"])
            : null;
        certificateVerificationAvailable =
            exam["certificateVerificationAvailable"] != null
                ? DateTime.parse(exam["certificateVerificationAvailable"])
                : null;
        important = exam["important"] != null
            ? DateTime.parse(exam["important"])
            : null;
        examDate =
            exam["examDate"] != null ? DateTime.parse(exam["examDate"]) : null;
        ageFrom =
            exam["ageFrom"] != null ? DateTime.parse(exam["ageFrom"]) : null;
        ageUpto =
            exam["ageUpto"] != null ? DateTime.parse(exam["ageUpto"]) : null;
        admitCardAvailableEdit = exam["admitCardAvailableEdit"] != null
            ? DateTime.parse(exam["admitCardAvailableEdit"])
            : null;
        answerKeyAvailableEdit = exam["answerKeyAvailableEdit"] != null
            ? DateTime.parse(exam["answerKeyAvailableEdit"])
            : null;
        resultPostModify = exam["resultPostModify"] != null
            ? DateTime.parse(exam["resultPostModify"])
            : null;
        correctiondateInForm = exam["correctiondateInForm"] != null &&
                exam["correctiondateInForm"] != ""
            ? DateTime.parse(exam["correctiondateInForm"])
            : null;
        jobPostingDate =
            exam["jobPostingDate"] != null && exam["jobPostingDate"] != ""
                ? DateTime.parse(exam["jobPostingDate"])
                : null;

        isadmitCardAvailable = exam["isadmitCardAvailable"] ?? false;
        isanswerKeyAvailable = exam["isanswerKeyAvailable"] ?? false;
        syllabusAvailable = exam["syllabusAvailable"] ?? false;
        resultAvailable = exam["resultAvailable"] ?? false;
        iscertificateVerificationAvailable =
            exam["iscertificateVerificationAvailable"] ?? false;
        isImportant = exam["isImportant"] ?? false;
        multiPost = exam["multiPost"] ?? false;
        shortNotice = exam["shortNotice"] ?? false;
        downloadBroucher = exam["downloadBroucher"] ?? false;
        correctionInForm = exam["correctionInForm"] ?? false;
      });
    } else {
      print("No exam data found for ${widget.examName}");
    }
  }

  void _addPostField() {
    setState(() {
      postControllers.add({
        "Postname": TextEditingController(),
        "TotalPost": TextEditingController(),
        "GeneralPost": TextEditingController(),
        "OBCPost": TextEditingController(),
        "EWSPost": TextEditingController(),
        "SCPost": TextEditingController(),
        "STPost": TextEditingController(),
        "eligibilityDetails":
            TextEditingController(text: selectedeligibilityDetails ?? ''),
      });
    });
  }

  void _savePost(int index) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        postDetails[index] = {
          "postName": postControllers[index]["Postname"]!.text,
          "totalPost": postControllers[index]["TotalPost"]!.text,
          "generalPost": postControllers[index]["GeneralPost"]!.text,
          "obcPost": postControllers[index]["OBCPost"]!.text,
          "ewsPost": postControllers[index]["EWSPost"]!.text,
          "scPost": postControllers[index]["SCPost"]!.text,
          "stPost": postControllers[index]["STPost"]!.text,
          "eligibilityDetails":
              postControllers[index]["eligibilityDetails"]!.text,
        };
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Post updated successfully!")));
    }
  }

  void _deletePost(int index) {
    setState(() {
      postControllers.removeAt(index);
      postDetails.removeAt(index);
    });
  }

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

  // Styled TextField
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return _styledCard(
      TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: white,
        ),
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  // Helper: Styled TextField with optional validation
  Widget _buildTextFieldWithValidation(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isRequired = false,
  }) {
    return _styledCard(
      TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: white,
        ),
        validator: isRequired
            ? (value) =>
                (value == null || value.isEmpty) ? "Enter $label" : null
            : null,
      ),
    );
  }

  int? parseNullableInt(String text) {
    return text.trim().isEmpty ? null : int.tryParse(text);
  }

  @override
  Widget build(BuildContext context) {
    final examViewModel = Provider.of<ExamViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final postViewModel = Provider.of<PostViewModel>(context);
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: bluegray,
          title: Center(
              child: Text("Update Exam", style: TextStyle(color: white)))),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Card(
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: isDesktop
                          ? screenWidth * 0.4
                          : isTablet
                              ? screenWidth * 0.7
                              : screenWidth * 0.95,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Required Field: Exam Name
                            _buildTextFieldWithValidation(
                                nameController, "Exam Name",
                                isRequired: true),

                            // Optional Text Fields (Short Information, Organization, etc.)
                            _buildTextFieldWithValidation(
                                shortInformationController,
                                "Short Information"),
                            _buildTextFieldWithValidation(
                                organizationNameController,
                                "Organization Name"),
                            _buildTextFieldWithValidation(
                                dashboardNameController, "Dashboard Name"),
                            _buildTextFieldWithValidation(
                                tileNameNameController, "Tile Name"),
                            _buildTextFieldWithValidation(
                                fullNameOfExamController, "Full Name Of Exam"),
                            _buildTextFieldWithValidation(
                                advertisementNoController, "Advertisement No"),
                            _buildTextFieldWithValidation(
                                howToPayController, "How To Pay"),
                            _buildTextFieldWithValidation(
                                ageRelaxationBriefController,
                                "Age Relaxation Brief"),
                            _buildTextFieldWithValidation(
                                applyOnlineController, "Apply Online"),
                            _buildTextFieldWithValidation(
                                downloadShortNoticeController,
                                "Download Short Notice"),
                            _buildTextFieldWithValidation(
                                downloadNotificationController,
                                "Download Notification"),
                            _buildTextFieldWithValidation(
                                officialWebsiteController, "Official Website"),
                            _buildTextFieldWithValidation(
                                broucherLinkController, "Broucher Link"),
                            _buildTextFieldWithValidation(
                                resultlinkController, "Result Link"),
                            _buildTextFieldWithValidation(
                                howToCheckResultController,
                                "How To Check Result"),
                            _buildTextFieldWithValidation(
                                howToFillFormController, "How To Fill Form"),
                            _buildTextFieldWithValidation(
                                howToDownloadAdmitCardController,
                                "How To Download Admit Card"),
                            _buildTextFieldWithValidation(
                                correctionInFormLinkController,
                                "Correction In Form Link"),

                            // Numeric Fields (Allowed to be null)
                            _buildTextFieldWithValidation(
                                minAgeController, "Min Age",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                maxAgeController, "Max Age",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                generalCategoryFeeController,
                                "General Category Fee",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                obcCategoryFeeController, "OBC Category Fee",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                ewsCategoryFeeController, "EWS Category Fee",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                scstCategoryFeeController, "SC/ST Category Fee",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                phCategoryFeeController, "PH Category Fee",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                womenCategoryFeeController,
                                "Women Category Fee",
                                isNumber: true),

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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                  value:
                                                      category["id"] as String,
                                                  child: Text(
                                                    category["name"] as String,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategory = value;
                                          });
                                          print(
                                              "Selected Category: $selectedCategory");
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Date Pickers
                            _buildDatePicker(
                                "Application Begin",
                                applicationBegin,
                                (date) =>
                                    setState(() => applicationBegin = date)),
                            _buildDatePicker(
                                "Last Date To Apply",
                                lastDateToApply,
                                (date) =>
                                    setState(() => lastDateToApply = date)),
                            _buildDatePicker(
                                "Last Date To Pay Exam Fee",
                                lastDateToPayExamFee,
                                (date) => setState(
                                    () => lastDateToPayExamFee = date)),
                            _buildDatePicker("Exam Date", examDate,
                                (date) => setState(() => examDate = date)),
                            _buildDatePicker("Age From", ageFrom,
                                (date) => setState(() => ageFrom = date)),
                            _buildDatePicker("Age Upto", ageUpto,
                                (date) => setState(() => ageUpto = date)),

                            // Checkbox with Date Pickers for Admit Card, Answer Key, Syllabus & Result
                            _buildCheckboxWithDate(
                                "Admit Card Available",
                                isadmitCardAvailable,
                                admitCardAvailable,
                                (val) =>
                                    setState(() => isadmitCardAvailable = val),
                                (date) =>
                                    setState(() => admitCardAvailable = date)),
                            _buildCheckboxWithDate(
                                "Answer Key Available",
                                isanswerKeyAvailable,
                                answerKeyAvailable,
                                (val) =>
                                    setState(() => isanswerKeyAvailable = val),
                                (date) =>
                                    setState(() => answerKeyAvailable = date)),
                            _buildCheckboxWithDate(
                                "Syllabus Available",
                                syllabusAvailable,
                                syllabusAvailableDate,
                                (val) =>
                                    setState(() => syllabusAvailable = val),
                                (date) => setState(
                                    () => syllabusAvailableDate = date)),
                            _buildCheckboxWithDate(
                                "Result Available",
                                resultAvailable,
                                resultPostingDate,
                                (val) => setState(() => resultAvailable = val),
                                (date) =>
                                    setState(() => resultPostingDate = date)),
                            _buildCheckboxWithDate(
                                "certificateVerification Available",
                                iscertificateVerificationAvailable,
                                certificateVerificationAvailable,
                                (val) => setState(() =>
                                    iscertificateVerificationAvailable = val),
                                (date) => setState(() =>
                                    certificateVerificationAvailable = date)),
                            _buildCheckboxWithDate(
                                "Important Available",
                                isImportant,
                                important,
                                (val) => setState(() => isImportant = val),
                                (date) => setState(() => important = date)),

                            // Additional Date Pickers for optional fields
                            _buildDatePicker(
                                "Admit Card Available Edit",
                                admitCardAvailableEdit,
                                (date) => setState(
                                    () => admitCardAvailableEdit = date)),
                            _buildDatePicker(
                                "Answer Key Available Edit",
                                answerKeyAvailableEdit,
                                (date) => setState(
                                    () => answerKeyAvailableEdit = date)),
                            _buildDatePicker(
                                "Result Post Modify",
                                resultPostModify,
                                (date) =>
                                    setState(() => resultPostModify = date)),
                            _buildDatePicker(
                                "Correction Date In Form",
                                correctiondateInForm,
                                (date) => setState(
                                    () => correctiondateInForm = date)),
                            _buildDatePicker(
                                "Job Posting Date",
                                jobPostingDate,
                                (date) =>
                                    setState(() => jobPostingDate = date)),

                            // Checkbox for multiPost, shortNotice, downloadBroucher, correctionInForm
                            _styledCard(
                              CheckboxListTile(
                                title: Text("Multi Post",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                value: multiPost,
                                onChanged: (val) =>
                                    setState(() => multiPost = val!),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            _styledCard(
                              CheckboxListTile(
                                title: Text("Short Notice",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                value: shortNotice,
                                onChanged: (val) =>
                                    setState(() => shortNotice = val!),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            _styledCard(
                              CheckboxListTile(
                                title: Text("Download Broucher",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                value: downloadBroucher,
                                onChanged: (val) =>
                                    setState(() => downloadBroucher = val!),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            _styledCard(
                              CheckboxListTile(
                                title: Text("Correction In Form",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                value: correctionInForm,
                                onChanged: (val) =>
                                    setState(() => correctionInForm = val!),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _addPostField,
                              child: Text("+ Add Posts"),
                            ),
                            SizedBox(height: 10),

                            ...List.generate(postControllers.length, (index) {
                              return _styledCard(
                                Column(
                                  children: [
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["Postname"]!,
                                        "Post Name",
                                        isRequired: true),
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["TotalPost"]!,
                                        "Total Post"),
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["GeneralPost"]!,
                                        "General Post",
                                        isNumber: true),
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["OBCPost"]!,
                                        "OBC Post",
                                        isNumber: true),
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["EWSPost"]!,
                                        "EWS Post",
                                        isNumber: true),
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["SCPost"]!,
                                        "SC Post",
                                        isNumber: true),
                                    _buildTextFieldWithValidation(
                                        postControllers[index]["STPost"]!,
                                        "ST Post",
                                        isNumber: true),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        hintText: "Select Eligibility Details",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        filled: true,
                                        fillColor: white,
                                      ),
                                      value: selectedeligibilityDetails,
                                      items: eligibilityViewModel.eligibilities
                                          .map((eligibility) =>
                                              DropdownMenuItem(
                                                value:
                                                    eligibility["id"] as String,
                                                child: Text(eligibility["name"]
                                                    as String),
                                              ))
                                          .toList(),
                                      onChanged: (value) => setState(() =>
                                          selectedeligibilityDetails = value),
                                      validator: (value) => value == null
                                          ? "Please select a eligibility"
                                          : null, // Validation
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _savePost(index);
                                            // if (Navigator.canPop(context)) {
                                            //   Navigator.pop(context);
                                            // }
                                          },
                                          child: Text("Save"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _deletePost(index);
                                            // if (Navigator.canPop(context)) {
                                            //   Navigator.pop(context);
                                            // }
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> updatedExam = {
                                    "name": nameController.text,
                                    "examCategory": selectedCategory,
                                    "postDate": DateTime.now()
                                        .toIso8601String(), // Example auto-generated field
                                    "shortInformation":
                                        shortInformationController.text,
                                    "organizationName":
                                        organizationNameController.text,
                                    "DashboardName":
                                        dashboardNameController.text,
                                    "tileName": tileNameNameController.text,
                                    "fullNameOfExam":
                                        fullNameOfExamController.text,
                                    "advertisementNo":
                                        advertisementNoController.text,
                                    "applicationBegin":
                                        applicationBegin?.toIso8601String(),
                                    "lastDateToApply":
                                        lastDateToApply?.toIso8601String(),
                                    "lastDateToPayExamFee":
                                        lastDateToPayExamFee?.toIso8601String(),
                                    "examDate": examDate?.toIso8601String(),
                                    "isadmitCardAvailable":
                                        isadmitCardAvailable,
                                    "admitCardAvailable":
                                        admitCardAvailable?.toIso8601String(),
                                    "admitCardAvailableEdit":
                                        admitCardAvailableEdit
                                            ?.toIso8601String(),
                                    "isanswerKeyAvailable":
                                        isanswerKeyAvailable,
                                    "answerKeyAvailable":
                                        answerKeyAvailable?.toIso8601String(),
                                    "answerKeyAvailableEdit":
                                        answerKeyAvailableEdit
                                            ?.toIso8601String(),
                                    "iscertificateVerificationAvailable":
                                        iscertificateVerificationAvailable,
                                    "certificateVerificationAvailable":
                                        certificateVerificationAvailable
                                            ?.toIso8601String(),
                                    "isImportant": isImportant,
                                    "important": important?.toIso8601String(),
                                    "generalCategoryFee": parseNullableInt(
                                        generalCategoryFeeController.text),
                                    "obcCategoryFee": parseNullableInt(
                                        obcCategoryFeeController.text),
                                    "ewsCategoryFee": parseNullableInt(
                                        ewsCategoryFeeController.text),
                                    "scstCategoryFee": parseNullableInt(
                                        scstCategoryFeeController.text),
                                    "phCategoryFee": parseNullableInt(
                                        phCategoryFeeController.text),
                                    "womenCategoryFee": parseNullableInt(
                                        womenCategoryFeeController.text),
                                    "howToPay": howToPayController.text,
                                    "minAge":
                                        parseNullableInt(minAgeController.text),
                                    "maxAge":
                                        parseNullableInt(maxAgeController.text),
                                    "ageRelaxationBrief":
                                        ageRelaxationBriefController.text,
                                    "ageFrom": ageFrom?.toIso8601String(),
                                    "ageUpto": ageUpto?.toIso8601String(),
                                    "multiPost": multiPost,
                                    "postDetails": postDetails,
                                    "applyOnline": applyOnlineController.text,
                                    "shortNotice": shortNotice,
                                    "downloadShortNotice":
                                        downloadShortNoticeController.text,
                                    "downloadNotification":
                                        downloadNotificationController.text,
                                    "officialWebsite":
                                        officialWebsiteController.text,
                                    "eligibilityCriteria":
                                        selectedeligibilityDetails,
                                    "downloadBroucher": downloadBroucher,
                                    "broucherLink": broucherLinkController.text,
                                    "syllabusAvailable": syllabusAvailable,
                                    "syllabusAvailableDate":
                                        syllabusAvailableDate
                                            ?.toIso8601String(),
                                    "resultAvailable": resultAvailable,
                                    "resultPostingDate":
                                        resultPostingDate?.toIso8601String(),
                                    "resultPostModify":
                                        resultPostModify?.toIso8601String(),
                                    "resultlink": resultlinkController.text,
                                    "howToCheckResult":
                                        howToCheckResultController.text,
                                    "howToFillForm":
                                        howToFillFormController.text,
                                    "howToDownloadAdmitCard":
                                        howToDownloadAdmitCardController.text,
                                    "correctionInForm": correctionInForm,
                                    "correctionInFormLink":
                                        correctionInFormLinkController.text,
                                    "correctiondateInForm":
                                        correctiondateInForm?.toIso8601String(),
                                    "jobPostingDate":
                                        jobPostingDate?.toIso8601String(),
                                  };

                                  await examViewModel.updateExam(
                                      widget.id, updatedExam);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Exam updated successfully!")));
                                  Navigator.pop(context, true);
                                }
                              },
                              child: Text("Update Exam"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
