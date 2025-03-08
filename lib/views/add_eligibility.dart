import 'package:admin_panel/constants/button.dart';
import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
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
  final TextEditingController eligiblityCriteriaController =
      TextEditingController();

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
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: white,
      ),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
       appBar: AppBar(
        backgroundColor: blue,
        title: Center(child: Row(
          children: [
            Image.asset("assets/images/app_logo.png", height: 30),
            SizedBox(width: 10),
            Text("Add Eligiblity Screen", style: TextStyle(color: white)),
          ],
        )),
      ),
      body: Container(
        color: bluegray50,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              context.go("/eligibilities"),
                                          icon: Icon(Icons.arrow_back)),
                                      Text(
                                        "Add Eligibilities",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                SizedBox(
                                  height: 20,
                                ),
                                _buildTextField(eligiblityCriteriaController,
                                    "eligiblityCriteria"),
                                // Submit Button
                                SizedBox(height: 20),

                                CustomButton(
                                  width: 200,
                                  text: "Add Eligibilities",
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, dynamic> neweligibility = {
                                        "eligiblityCriteria":
                                            eligiblityCriteriaController.text,
                                      };

                                      // Call ViewModel to add eligibility
                                      await eligibilityViewModel
                                          .addEligibility(neweligibility);

                                      // Show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "eligibility added successfully!")),
                                      );

                                      // Close screen
                                      context.go('/eligibilities');
                                    }
                                  },
                                  textColor: Colors.white,
                                  borderRadius: 8.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
