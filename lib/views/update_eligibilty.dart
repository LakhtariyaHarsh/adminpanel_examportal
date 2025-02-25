import 'package:admin_panel/view_models/Eligibility_view_model.dart';
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
        nameController = TextEditingController(text: eligibility["eligiblityCriteria"]);
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
      color: Colors.white,
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
          fillColor: Colors.white,
        ),
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 146, 156, 160),
          title: Text("Update Eligibility", style: TextStyle(color: Colors.white))),
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
                            _buildTextField(nameController, "EligibilityDetails"),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> updatedEligibility = {
                                    "eligiblityCriteria": nameController.text,
                                  };

                                  await eligibilityViewModel.updateEligibility(
                                      widget.id, updatedEligibility);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Eligibility updated successfully!")));
                                  context.go('/eligibilities');
                                }
                              },
                              child: Text("Update eligibility"),
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
