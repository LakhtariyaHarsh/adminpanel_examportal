import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddEligibility extends StatefulWidget {
  const AddEligibility({super.key});

  @override
  State<AddEligibility> createState() => _AddEligibilityState();
}

class _AddEligibilityState extends State<AddEligibility> {
  final _formKey = GlobalKey<FormState>();
  // Controllers for text fields
  final TextEditingController eligiblityCriteriaController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: bluegray,
          title: Center(child: Text("Add eligibility", style: TextStyle(color: white)))),
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
                width: isDesktop ? screenWidth * 0.4 : isTablet ? screenWidth * 0.7 : screenWidth * 0.95,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(eligiblityCriteriaController, "eligiblityCriteria"),

                      // Submit Button
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> neweligibility = {
                              "eligiblityCriteria": eligiblityCriteriaController.text,
                            };

                            // Call ViewModel to add eligibility
                            await eligibilityViewModel.addEligibility(neweligibility);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("eligibility added successfully!")),
                            );

                            // Close screen
                            context.go('/eligibilities');
                          }
                        },
                        child: Text("Add eligibility"),
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
