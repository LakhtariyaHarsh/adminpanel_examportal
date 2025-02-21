import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/exam_view_model.dart';
import '../view_models/auth_view_model.dart';
import 'add_exam_screen.dart';
import 'update_exam_screen.dart';
import 'login_screen.dart';
import 'category.dart' as category_view;

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final examViewModel = Provider.of<ExamViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter exams based on search query
    final filteredExams = examViewModel.exams.where((exam) {
      final name = exam["name"]?.toLowerCase() ?? "";
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 156, 160),
        title: Text("Admin Dashboard Exams" ,style: TextStyle(color: Colors.white),),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => category_view.Category()),
                  );
                },
                child: Text("Category", style: TextStyle(color: Colors.white)),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddExamScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: examViewModel.isLoading
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
                          itemCount: filteredExams.length,
                          itemBuilder: (context, index) {
                            final exam = filteredExams[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  exam["name"] ?? "",
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateExamScreen(
                                                examName: exam["name"] ?? "",
                                                id: exam["id"] ?? "",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          examViewModel.deleteExam(exam["id"] ?? "");
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
