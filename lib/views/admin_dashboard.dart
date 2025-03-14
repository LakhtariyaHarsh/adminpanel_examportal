import 'package:admin_panel/constants/button.dart';
import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/exam_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamViewModel>(context, listen: false).fetchExams();
    });
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
    bool isTablet = screenWidth > 600;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Center(
            child: Row(
          children: [
            Image.asset("assets/images/app_logo.png", height: 30),
            SizedBox(width: 10),
            Text("Exam Screen", style: TextStyle(color: white)),
          ],
        )),
      ),
      drawer: isDesktop
          ? null
          : CustomDrawer(
              onLogout: () => authViewModel.logout(),
            ),
      body: Row(
        children: [
          //Drawer for desktop
          isDesktop
              ? CustomDrawer(
                  onLogout: () => authViewModel.logout(),
                )
              : SizedBox(),
          examViewModel.isLoading && examViewModel.exams.isEmpty
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  // Use Expanded here
                  child: Container(
                    color: bluegray50,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "All Exams",
                                style: TextStyle(fontSize: 30),
                              ),
                              Divider(),
                              SizedBox(height: 20),
                              // Search Bar
                              isDesktop || isTablet
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Search Field with Fixed Width
                                        SizedBox(
                                          width:
                                              300, // Set fixed width for the search field
                                          child: TextField(
                                            controller: _searchController,
                                            onChanged: (value) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                if (value.isEmpty) {
                                                  examViewModel.clearSearch();
                                                } else {
                                                  examViewModel
                                                      .searchExams(value);
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Search Exams",
                                              prefixIcon: Icon(Icons.search),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              filled: true,
                                              fillColor: white,
                                            ),
                                          ),
                                        ),

                                        // Button with Fixed Width
                                        SizedBox(
                                            width:
                                                150, // Set fixed width for the button
                                            height:
                                                50, // Optional: Set fixed height
                                            child: CustomButton(
                                              text: "Add Exam",
                                              route: "/exams/add",
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              borderRadius: 8.0,
                                            )),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Search Field with Fixed Width
                                        TextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              if (value.isEmpty) {
                                                examViewModel.clearSearch();
                                              } else {
                                                examViewModel
                                                    .searchExams(value);
                                              }
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Search Exams",
                                            prefixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            filled: true,
                                            fillColor: white,
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        // Button with Fixed Width
                                        SizedBox(
                                            width:
                                                150, // Set fixed width for the button
                                            height:
                                                50, // Optional: Set fixed height
                                            child: CustomButton(
                                              text: "Add Exam",
                                              route: "/exams/add",
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              borderRadius: 8.0,
                                            )),
                                      ],
                                    ),
                              SizedBox(height: 20),
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: displayedExams.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == displayedExams.length) {
                                      return examViewModel.isLoadingMore
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : SizedBox();
                                    }
                                    final exam = displayedExams[index];
                                    return Card(
                                      color: bluegray50,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                                    color: blue),
                                                onPressed: () async {
                                                  GoRouter.of(context).push(
                                                    '/exams/update/${exam["id"]}/${Uri.encodeComponent(exam["name"] ?? "")}/${exam["examcategory"]}?postid=${exam["postDetails"] ?? ""}&eligibilityid=${exam["eligibilityCriteria"] ?? ""}',
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: red),
                                                onPressed: () async {
                                                  bool success =
                                                      await examViewModel
                                                              .deleteExam(
                                                                  exam["id"] ??
                                                                      "") ??
                                                          false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(success
                                                            ? "Exam deleted successfully"
                                                            : "Failed to delete exam")),
                                                  );
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
                  ),
                ),
        ],
      ),
    );
  }
}
