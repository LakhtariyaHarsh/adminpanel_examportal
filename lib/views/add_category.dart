import 'package:admin_panel/constants/button.dart';
import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController CategorynameController = TextEditingController();

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
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
       appBar: AppBar(
        backgroundColor: blue,
        title: Center(child: Row(
          children: [
            Image.asset("assets/images/app_logo.png", height: 30),
            SizedBox(width: 10),
            Text("Add Category Screen", style: TextStyle(color: white)),
          ],
        )),
      ),
      drawer: isDesktop
          ? null
          : CustomDrawer(
              onLogout: () => authViewModel.logout(),
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
                                              context.go("/categories"),
                                          icon: Icon(Icons.arrow_back)),
                                      Text(
                                        "Add Category",
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
                                    CategorynameController, "category Name"),
                                // Submit Button
                                SizedBox(height: 20),

                                CustomButton(
                                  width: 200,
                                  text: "Add category",
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, dynamic> newcategory = {
                                        "categoryName":
                                            CategorynameController.text,
                                      };

                                      // Call ViewModel to add category
                                      await categoryViewModel
                                          .addCategory(newcategory);

                                      // Show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "category added successfully!")),
                                      );

                                      // Close screen
                                      context.go('/categories');
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
