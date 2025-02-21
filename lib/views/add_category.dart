import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:flutter/material.dart';
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
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(title: Text("Add category")),
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
                width: screenWidth * 0.5,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(CategorynameController, "category Name"),
                      

                      // Submit Button
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> newcategory = {
                              "categoryName": CategorynameController.text,                             
                            };

                            // Call ViewModel to add category
                            await categoryViewModel.addcategory(newcategory);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("category added successfully!")),
                            );

                            // Close screen
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Add category"),
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
