import 'package:admin_panel/services/exam_service.dart';
import 'package:admin_panel/view_models/exam_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  // Local state for exam fetching similar to latestjob.dart
  List<Map<String, String>> examList = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int page = 1;
  int limit = 20; // You can adjust this as needed
  int totalPages = 1;

  final ScrollController _scrollController = ScrollController();
  final ExamService _apiService =
      ExamService(); // Make sure you have an ApiService

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Fetch the initial data
    fetchExams();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Scroll listener to detect near-bottom scrolling
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      if (page < totalPages) {
        page++; // Increment page
        fetchExams(isLoadMore: true);
      }
    }
  }

  // Fetch Exams with Pagination (Store ID & Name)
  Future<void> fetchExams({bool isLoadMore = false}) async {
    if (isLoadMore && (isLoadingMore || page > totalPages)) return;

    try {
      if (isLoadMore) {
        setState(() => isLoadingMore = true);
      } else {
        setState(() => isLoading = true);
      }

      Map<String, dynamic> data = await _apiService.fetchExams(page, limit);

      setState(() {
        // Append exams as a list of maps (id & name)
        examList.addAll(data["exams"]
            .where((exam) => exam["_id"] != null && exam["name"] != null)
            .map<Map<String, String>>((exam) {
          // Extract the examCategory _id if available, otherwise use an empty string.
          String categoryId = "";
          if (exam["examCategory"] != null) {
            categoryId = exam["examCategory"] is Map
                ? exam["examCategory"]["_id"].toString()
                : exam["examCategory"].toString();
          }
          return {
            "id": exam["_id"].toString(),
            "name": exam["name"].toString(),
            "examcategory": categoryId,
          };
        }).toList());

        totalPages = data["totalPages"]; // Update total pages
        isLoading = false;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
      print("Error fetching exams: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final examViewModel = Provider.of<ExamViewModel>(context);
    final isSearching = _searchQuery.isNotEmpty;
    final displayedExams = isSearching ? examViewModel.searchResults : examList;
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
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
                        // Navigate to Posts Screen (Replace with actual screen)
                      },
                      child:
                          Text("Posts", style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Eligibility Screen (Replace with actual screen)
                      },
                      child: Text("Eligibility",
                          style: TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        authViewModel.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
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
                              print("object");
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
      body: isLoading && examList.isEmpty
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
                          setState(() {
                            _searchQuery = value;
                          });

                          final examViewModel = Provider.of<ExamViewModel>(
                              context,
                              listen: false);

                          if (value.isEmpty) {
                            examViewModel
                                .clearSearch(); // Clear results when search is empty
                          } else {
                            examViewModel.searchExams(value); // Perform search
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
                      // Exam List using ListView.builder with loader appended at the bottom
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: displayedExams.length +
                              1, // Extra item for loader
                          itemBuilder: (context, index) {
                            if (index == displayedExams.length) {
                              return isLoadingMore
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
                                        onPressed: () {
                                          print(exam["examcategory"]);
                                          context.go(
                                              '/exams/update/${exam["id"]}/${Uri.encodeComponent(exam["name"] ?? "")}/${exam["examcategory"] ?? ""}');
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Delete logic can be implemented here, such as calling a delete API
                                          // For now, we simply remove the exam locally and rebuild the list.
                                          setState(() {
                                            examList.removeWhere(
                                                (e) => e['id'] == exam["id"]);
                                          });
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
