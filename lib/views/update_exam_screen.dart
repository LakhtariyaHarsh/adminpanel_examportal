import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/exam_view_model.dart';

class UpdateExamScreen extends StatefulWidget {
  final String examName;
  final String id;
  final String categoryid;

  UpdateExamScreen(
      {required this.examName, required this.id, required this.categoryid});

  @override
  _UpdateExamScreenState createState() => _UpdateExamScreenState();
}

class _UpdateExamScreenState extends State<UpdateExamScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController minAgeController;
  late TextEditingController maxAgeController;
  late TextEditingController generalCategoryFeeController;
  late TextEditingController obcCategoryFeeController;
  late TextEditingController ewsCategoryFeeController;
  late TextEditingController scstCategoryFeeController;
  late TextEditingController phCategoryFeeController;

  // Date fields
  DateTime? applicationBegin;
  DateTime? lastDateToApply;
  DateTime? lastDateToPayExamFee;
  DateTime? admitCardAvailable;
  DateTime? answerKeyAvailable;
  DateTime? syllabusAvailableDate;
  DateTime? resultPostingDate;
  DateTime? examDate;
  DateTime? ageFrom;

  // Selected category id and name
  String? selectedCategory;
  String? selectedCategoryName;

  bool isadmitCardAvailable = false;
  bool isanswerKeyAvailable = false;
  bool syllabusAvailable = false;
  bool resultAvailable = false;

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
        examDate =
            exam["examDate"] != null ? DateTime.parse(exam["examDate"]) : null;
        ageFrom =
            exam["ageFrom"] != null ? DateTime.parse(exam["ageFrom"]) : null;

        isadmitCardAvailable = exam["isadmitCardAvailable"] ?? false;
        isanswerKeyAvailable = exam["isanswerKeyAvailable"] ?? false;
        syllabusAvailable = exam["syllabusAvailable"] ?? false;
        resultAvailable = exam["resultAvailable"] ?? false;
      });
    } else {
      print("No exam data found for ${widget.examName}");
    }
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
      color: Colors.white,
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
          fillColor: Colors.white,
        ),
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final examViewModel = Provider.of<ExamViewModel>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 146, 156, 160),
          title: Text("Update Exam", style: TextStyle(color: Colors.white))),
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
                      width: isDesktop ? screenWidth * 0.4 : isTablet ? screenWidth * 0.7 : screenWidth * 0.95,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(nameController, "Exam Name"),
                            _styledCard(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                          fillColor: Colors.white,
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
                            SizedBox(
                              height: 20,
                            ),
                            _buildDatePicker(
                                "Application Begin Date",
                                applicationBegin,
                                (date) =>
                                    setState(() => applicationBegin = date)),
                            _buildDatePicker(
                                "Last Date to Apply",
                                lastDateToApply,
                                (date) =>
                                    setState(() => lastDateToApply = date)),
                            _buildDatePicker(
                                "Last Date to Pay Exam Fee",
                                lastDateToPayExamFee,
                                (date) => setState(
                                    () => lastDateToPayExamFee = date)),
                            _buildCheckboxWithDate(
                                "Admit Card Available",
                                isadmitCardAvailable,
                                admitCardAvailable,
                                (value) => setState(
                                    () => isadmitCardAvailable = value),
                                (date) =>
                                    setState(() => admitCardAvailable = date)),
                            _buildCheckboxWithDate(
                                "Answer Key Available",
                                isanswerKeyAvailable,
                                answerKeyAvailable,
                                (value) => setState(
                                    () => isanswerKeyAvailable = value),
                                (date) =>
                                    setState(() => answerKeyAvailable = date)),
                            _buildCheckboxWithDate(
                                "Syllabus Available",
                                syllabusAvailable,
                                syllabusAvailableDate,
                                (value) =>
                                    setState(() => syllabusAvailable = value),
                                (date) => setState(
                                    () => syllabusAvailableDate = date)),
                            _buildCheckboxWithDate(
                                "Result Available",
                                resultAvailable,
                                resultPostingDate,
                                (value) =>
                                    setState(() => resultAvailable = value),
                                (date) =>
                                    setState(() => resultPostingDate = date)),
                            _buildDatePicker("Exam Date", examDate,
                                (date) => setState(() => examDate = date)),
                            _buildDatePicker("Age From", ageFrom,
                                (date) => setState(() => ageFrom = date)),
                            _buildTextField(minAgeController, "Min Age",
                                isNumber: true),
                            _buildTextField(maxAgeController, "Max Age",
                                isNumber: true),
                            _buildTextField(generalCategoryFeeController,
                                "General Category Fee",
                                isNumber: true),
                            _buildTextField(
                                obcCategoryFeeController, "OBC Category Fee",
                                isNumber: true),
                            _buildTextField(
                                ewsCategoryFeeController, "EWS Category Fee",
                                isNumber: true),
                            _buildTextField(
                                scstCategoryFeeController, "SC/ST Category Fee",
                                isNumber: true),
                            _buildTextField(
                                phCategoryFeeController, "PH Category Fee",
                                isNumber: true),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> updatedExam = {
                                    "name": nameController.text,
                                    "examCategory": selectedCategory,
                                    "minAge": int.parse(minAgeController.text),
                                    "maxAge": int.parse(maxAgeController.text),
                                    "generalCategoryFee": int.parse(
                                        generalCategoryFeeController.text),
                                    "obcCategoryFee": int.parse(
                                        obcCategoryFeeController.text),
                                    "ewsCategoryFee": int.parse(
                                        ewsCategoryFeeController.text),
                                    "scstCategoryFee": int.parse(
                                        scstCategoryFeeController.text),
                                    "phCategoryFee":
                                        int.parse(phCategoryFeeController.text),

                                    // Store Dates (Convert to ISO format)
                                    "applicationBegin":
                                        applicationBegin?.toIso8601String(),
                                    "lastDateToApply":
                                        lastDateToApply?.toIso8601String(),
                                    "lastDateToPayExamFee":
                                        lastDateToPayExamFee?.toIso8601String(),
                                    "admitCardAvailable":
                                        admitCardAvailable?.toIso8601String(),
                                    "answerKeyAvailable":
                                        answerKeyAvailable?.toIso8601String(),
                                    "syllabusAvailableDate":
                                        syllabusAvailableDate
                                            ?.toIso8601String(),
                                    "resultPostingDate":
                                        resultPostingDate?.toIso8601String(),
                                    "examDate": examDate?.toIso8601String(),
                                    "ageFrom": ageFrom?.toIso8601String(),

                                    // Store Boolean Values
                                    "isadmitCardAvailable":
                                        isadmitCardAvailable,
                                    "isanswerKeyAvailable":
                                        isanswerKeyAvailable,
                                    "syllabusAvailable": syllabusAvailable,
                                    "resultAvailable": resultAvailable,
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
