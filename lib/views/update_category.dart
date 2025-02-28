import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdateCategory extends StatefulWidget {
  final String id;
  const UpdateCategory({super.key, required this.id});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController nameController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay fetch until after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchcategoryData();
    });
  }

  // Fetch category details by id and store selected category name
  Future<void> fetchcategoryData() async {
    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);
    await categoryViewModel.fetchCategoryById(widget.id);
    final category = categoryViewModel.selectedCategory;

    if (category != null) {
      setState(() {
        nameController = TextEditingController(text: category["categoryName"]);
        isLoading = false;
      });
    } else {
      print("No category data found for ${widget.id}");
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: bluegray,
          title: Text("Update Category", style: TextStyle(color: white))),
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
                            _buildTextField(nameController, "Category Name"),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> updatedCategory = {
                                    "categoryName": nameController.text,
                                  };

                                  await categoryViewModel.updateCategory(
                                      widget.id, updatedCategory);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Category updated successfully!")));
                                  context.go('/categories');
                                }
                              },
                              child: Text("Update category"),
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
