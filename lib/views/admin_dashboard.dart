import 'package:admin_panel/view_models/exam_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'add_exam_screen.dart';
import 'update_exam_screen.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final examViewModel = Provider.of<ExamViewModel>(context, listen: false);
    // Initially load exams
    examViewModel.fetchExams();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final examViewModel = Provider.of<ExamViewModel>(context, listen: false);
    // When scrolled near the bottom, load more exams if needed.
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !examViewModel.isLoadingMore &&
        examViewModel.page < examViewModel.totalPages) {
      examViewModel.page++;
      examViewModel.fetchExams(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final examViewModel = Provider.of<ExamViewModel>(context);
    // If there is an active search (i.e. search controller is not empty)
    // display search results, otherwise show full exams list.
    final displayedExams = _searchController.text.isNotEmpty
        ? examViewModel.searchResults
        : examViewModel.exams;
    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 156, 160),
        title: Text("Admin Dashboard Exams",
            style: TextStyle(color: Colors.white)),
        actions: screenWidth >= 720
            ? [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go('/categories');
                      },
                      child: Text("Category",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Posts Screen (replace with your screen)
                      },
                      child: Text("Posts",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Eligibility Screen (replace with your screen)
                      },
                      child: Text("Eligibility",
                          style: TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        authViewModel.logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ]
            : null,
      ),
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: const Color(0xffe3e4e6),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 244, 245, 246),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              size: 40,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "ADMIN DASHBOARD",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.school,
                                color: Colors.blueGrey),
                            title: const Text("Exams"),
                            onTap: () {
                              context.go('/');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.category,
                                color: Colors.blueGrey),
                            title: const Text("Category"),
                            onTap: () {
                              context.go('/categories');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.article,
                                color: Colors.blueGrey),
                            title: const Text("Posts"),
                            onTap: () {},
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.verified_user,
                                color: Colors.blueGrey),
                            title: const Text("Eligibility"),
                            onTap: () {},
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.logout,
                                color: Colors.blueGrey),
                            title: const Text("Logout"),
                            onTap: () {
                              authViewModel.logout();
                              context.go('/login');
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/exams/add');
        },
        child: Icon(Icons.add),
      ),
      body: examViewModel.isLoading && examViewModel.exams.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: isDesktop ? screenWidth * 0.7 : screenWidth * 0.95,
                color: Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          // If search query is empty, clear search results.
                          if (value.isEmpty) {
                            examViewModel.clearSearch();
                          } else {
                            // Otherwise, perform search.
                            examViewModel.searchExams(value);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Search Exams",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: displayedExams.length +
                              1, // Add extra item for a loading indicator if needed.
                          itemBuilder: (context, index) {
                            if (index == displayedExams.length) {
                              return examViewModel.isLoadingMore
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox();
                            }
                            final exam = displayedExams[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  exam["name"] ?? "",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateExamScreen(
                                                id: exam["id"] ?? "",
                                                examName: exam["name"] ?? "",
                                                categoryid:
                                                    exam["examcategory"] ?? "",
                                              ),
                                            ),
                                          );
                                          if (updated == true) {
                                            // After updating, refresh the exams list.
                                            examViewModel.fetchExams();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Exam updated successfully")),
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          bool success = await examViewModel
                                                  .deleteExam(exam["id"] ?? "") ??
                                              false;
                                          if (success) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Exam deleted successfully")),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Failed to delete exam")),
                                            );
                                          }
                                        },
                                      )
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
