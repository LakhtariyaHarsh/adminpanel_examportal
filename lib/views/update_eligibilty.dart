import 'package:admin_panel/constants/button.dart';
import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdateEligibility extends StatefulWidget {
  final String id;
  const UpdateEligibility({super.key, required this.id});

  @override
  State<UpdateEligibility> createState() => _UpdateEligibilityState();
}

class _UpdateEligibilityState extends State<UpdateEligibility> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController nameController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay fetch until after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetcheligibilityData();
    });
  }

  // Fetch eligibility details by id and store selected eligibility name
  Future<void> fetcheligibilityData() async {
    final eligibilityViewModel =
        Provider.of<EligibilityViewModel>(context, listen: false);
    await eligibilityViewModel.fetchEligibilityById(widget.id);
    final eligibility = eligibilityViewModel.selectedEligibility;

    if (eligibility != null) {
      setState(() {
        nameController =
            TextEditingController(text: eligibility["eligiblityCriteria"]);
        isLoading = false;
      });
    } else {
      print("No eligibility data found for ${widget.id}");
      setState(() {
        isLoading = false;
      });
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
    ;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
       appBar: AppBar(
        backgroundColor: blue,
        title: Center(child: Row(
          children: [
            Image.asset("assets/images/app_logo.png", height: 30),
            SizedBox(width: 10),
            Text("Update Eligibility Screen", style: TextStyle(color: white)),
          ],
        )),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                                                onPressed: () => context
                                                    .go("/eligibilities"),
                                                icon: Icon(Icons.arrow_back)),
                                            Text(
                                              "Update Eligibilities",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      _buildTextField(
                                          nameController, "EligibilityDetails"),
                                      // Submit Button
                                      SizedBox(height: 20),

                                      CustomButton(
                                        width: 200,
                                        text: "Update Eligibilities",
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Map<String, dynamic>
                                                updatedEligibility = {
                                              "eligiblityCriteria":
                                                  nameController.text,
                                            };

                                            await eligibilityViewModel
                                                .updateEligibility(widget.id,
                                                    updatedEligibility);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Eligibility updated successfully!")));
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
