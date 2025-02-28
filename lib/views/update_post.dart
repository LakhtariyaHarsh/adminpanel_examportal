import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePostScreen extends StatefulWidget {
  final String postName;
  final String id;
  final String eligibilityid;

  UpdatePostScreen(
      {required this.postName, required this.id, required this.eligibilityid});

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController PostnameController = TextEditingController();
  late TextEditingController TotalPostController;
  late TextEditingController generalPostController;
  late TextEditingController obcPostController;
  late TextEditingController ewsPostController;
  late TextEditingController scPostController;
  late TextEditingController stPostController;

  // Selected category id and name
  String? selectedeligibilityDetails;
  String? selectedEligibilityDetailsName;

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
      await fetchEligibilityData();
      await fetchPostData();
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

  // Fetch post details by name and store selected category name from post data if available.
  Future<void> fetchPostData() async {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    await postViewModel.fetchPostById(widget.id);
    final post = postViewModel.selectedpost;

    if (post != null) {
      setState(() {
        PostnameController = TextEditingController(text: post["postName"]);
        // If post contains postCategory, extract its _id (if it is a map) or use the value directly.
        if (post["eligiblityDetails"] != null) {
          selectedeligibilityDetails = post["eligiblityDetails"] is Map
              ? post["eligiblityDetails"]["_id"].toString()
              : post["eligiblityDetails"].toString();
          // Optionally, if post data contains category name (for instance, post["categoryName"]), use that:
          if (post["eligiblityCriteria"] != null) {
            selectedEligibilityDetailsName =
                post["eligiblityCriteria"].toString();
          }
        }

        TotalPostController =
            TextEditingController(text: post["totalPost"]?.toString() ?? '');
        generalPostController =
            TextEditingController(text: post["generalPost"]?.toString() ?? '');
        obcPostController = TextEditingController(
            text: post["obcPost"]?.toString() ?? '');
        ewsPostController = TextEditingController(
            text: post["ewsPost"]?.toString() ?? '');
        scPostController = TextEditingController(
            text: post["scPost"]?.toString() ?? '');
        stPostController = TextEditingController(
            text: post["stPost"]?.toString() ?? '');
      });
    } else {
      print("No post data found for ${widget.postName}");
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
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    final postViewModel = Provider.of<PostViewModel>(context);
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: bluegray,
          title: Center(child: Text("Update Exam", style: TextStyle(color: white)))),
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
                                PostnameController, "Post Name",
                                isRequired: true),

                            // Numeric Fields (Allowed to be null)
                            _buildTextFieldWithValidation(
                                TotalPostController, "Total Post",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                generalPostController, "General Post",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                obcPostController, "OBC Post",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                ewsPostController, "EWS Post",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                scPostController, "SC Post",
                                isNumber: true),
                            _buildTextFieldWithValidation(
                                stPostController, "ST Post",
                                isNumber: true),

                            // Category Dropdown
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
                                          hintText:
                                              "Select Eligibility Details",
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
                                        value: selectedeligibilityDetails,
                                        items: eligibilityViewModel
                                            .eligibilities
                                            .map((eligibility) =>
                                                DropdownMenuItem(
                                                  value: eligibility["id"]
                                                      as String,
                                                  child: Text(
                                                    eligibility["name"]
                                                        as String,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedeligibilityDetails = value;
                                          });
                                          print(
                                              "Selected eligibility: $selectedeligibilityDetails");
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> updatedPost = {
                                    "postName": PostnameController.text,
                                    "eligiblityDetails": selectedeligibilityDetails,
                                    "totalPost": parseNullableInt(TotalPostController.text),
                                    "generalPost": parseNullableInt(generalPostController.text),
                                    "obcPost": parseNullableInt(obcPostController.text),
                                    "ewsPost": parseNullableInt(ewsPostController.text),
                                    "scPost": parseNullableInt(scPostController.text),
                                    "stPost": parseNullableInt(stPostController.text),

                                  };

                                  await postViewModel.updatePost(
                                      widget.id, updatedPost);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Post updated successfully!")));
                                  Navigator.pop(context, true);
                                }
                              },
                              child: Text("Update Post"),
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

  Widget buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number);
  }

}
