import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/views/add_category.dart';
import 'package:admin_panel/views/admin_dashboard.dart';
import 'package:admin_panel/views/update_category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../services/category_service.dart';
import 'login_screen.dart';

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  List<Map<String, String>> categoryList = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int page = 1;
  int limit = 20;
  int totalPages = 1;

  ScrollController _scrollController = ScrollController();
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll Listener for Pagination
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        page < totalPages) {
      page++;
      fetchCategories(isLoadMore: true);
    }
  }

  // Fetch Categories with Pagination
  Future<void> fetchCategories({bool isLoadMore = false}) async {
    if (isLoadMore && (isLoadingMore || page > totalPages)) return;

    try {
      if (isLoadMore) {
        setState(() => isLoadingMore = true);
      } else {
        setState(() => isLoading = true);
      }

      Map<String, dynamic> data =
          await _categoryService.fetchCategory(page, limit);

      setState(() {
        categoryList.addAll(data["categories"]
            .where((category) =>
                category["_id"] != null && category["categoryName"] != null)
            .map<Map<String, String>>((category) {
          return {
            "id": category["_id"].toString(),
            "name": category["categoryName"].toString(),
          };
        }).toList());

        totalPages = data["totalPages"];
        isLoading = false;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
      print("Error fetching categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final bool isSearching = _searchQuery.isNotEmpty;
    final displayedCategories = isSearching
        ? categoryViewModel.searchResults
        : categoryViewModel.categories;

    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isTablet = screenWidth >= 720 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 156, 160),
        title: Text("CATEGORIES", style: TextStyle(color: Colors.white)),
        actions: screenWidth >= 720
            ? [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                       context.go('/');
                      },
                      child:
                          Text("Exams", style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child:
                          Text("Posts", style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {},
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
                                builder: (context) => LoginScreen()));
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
          context.go('/categories/add');
        },
        child: Icon(Icons.add),
      ),
      body: isLoading && categoryList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: isDesktop ? screenWidth * 0.7 : screenWidth * 0.95,
                color: Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // 🔹 Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });

                          final categoryViewModel =
                              Provider.of<CategoryViewModel>(context,
                                  listen: false);

                          if (value.isEmpty) {
                            categoryViewModel.clearSearch();
                          } else {
                            categoryViewModel.searchCategories(value);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Search Categories",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Category List with Pagination
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: displayedCategories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == displayedCategories.length) {
                              return isLoadingMore
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox();
                            }

                            final category = displayedCategories[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  category["name"] ?? "",
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
                                          context.go(
                                              '/categories/update/${category["id"]}');
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            categoryList.removeWhere((c) =>
                                                c['id'] == category["id"]);
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
