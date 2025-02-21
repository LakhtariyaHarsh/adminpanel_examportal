import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/views/add_category.dart';
import 'package:admin_panel/views/admin_dashboard.dart';
import 'package:admin_panel/views/update_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'login_screen.dart';

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter exams based on search query
    final filteredcategories = categoryViewModel.categories.where((category) {
      final name = category["categoryName"]?.toLowerCase() ?? "";
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 156, 160),
        title: Text("CATEGORIES" ,style: TextStyle(color: Colors.white),),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                  );
                },
                child: Text("Exams", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Posts Screen (Replace with actual screen)
                },
                child: Text("Posts", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Eligibility Screen (Replace with actual screen)
                },
                child: Text("Eligibility", style: TextStyle(color: Colors.white)),
              ),
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  authViewModel.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: categoryViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: screenWidth * 0.7,
                color: Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Search Exams",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Exam List
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredcategories.length,
                          itemBuilder: (context, index) {
                            final category = filteredcategories[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  category["name"] ?? "",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          print(category["id"]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateCategory(id: category["id"] ?? "")
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          categoryViewModel.deletecategory(category["id"] ?? "");
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
