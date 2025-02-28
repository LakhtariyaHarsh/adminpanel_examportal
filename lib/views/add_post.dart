import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController PostnameController = TextEditingController();
  final TextEditingController TotalPostController = TextEditingController();
  final TextEditingController generalPostController = TextEditingController();
  final TextEditingController obcPostController = TextEditingController();
  final TextEditingController ewsPostController = TextEditingController();
  final TextEditingController scPostController = TextEditingController();
  final TextEditingController stPostController = TextEditingController();

  String? selectedeligibilityDetails;

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

  // Styled TextField
  Widget _buildTextField(
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

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: bluegray,
          title: Center(child: Text("Add Post", style: TextStyle(color: white)))),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      _buildTextField(PostnameController, "Post Name", isRequired: true),

                      _buildTextField(TotalPostController, "Total Post"),
                      _buildTextField(generalPostController, "General Post",
                          isNumber: true),
                      _buildTextField(obcPostController, "OBC Post",
                          isNumber: true),
                      _buildTextField(ewsPostController, "EWS Post",
                          isNumber: true),
                      _buildTextField(scPostController, "SC Post",
                          isNumber: true),
                      _buildTextField(stPostController, "ST Post",
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
                                    hintText: "Select Eligibility Details",
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
                                  value: selectedeligibilityDetails,
                                  items: eligibilityViewModel.eligibilities
                                      .map((eligibility) => DropdownMenuItem(
                                            value: eligibility["id"] as String,
                                            child: Text(
                                              eligibility["name"] as String,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedeligibilityDetails = value;
                                    });
                                    print(
                                        "Selected Category: $selectedeligibilityDetails");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Submit Button
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> newPost = {
                              "postName": PostnameController.text,
                              "totalPost": TotalPostController.text,
                              "generalPost": generalPostController.text,
                              "obcPost": obcPostController.text,
                              "ewsPost": ewsPostController.text,
                              "scPost": scPostController.text,
                              "stPost": stPostController.text,
                              "eligiblityDetails": selectedeligibilityDetails,
                            };

                            // Call ViewModel to add Post
                            await postViewModel.addPost(newPost);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Post added successfully!")),
                            );

                            // Close screen
                            context.go('/posts');
                          }
                        },
                        child: Text("Add Post"),
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
}
