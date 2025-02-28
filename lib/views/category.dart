import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class Category extends StatefulWidget {
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);
    // Fetch initial categories.
    categoryViewModel.fetchCategories();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Scroll listener that triggers load-more when near bottom.
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      // If not loading and more pages exist, fetch more.
      if (!categoryViewModel.isLoading &&
          categoryViewModel.page < categoryViewModel.totalPages) {
        categoryViewModel.fetchCategories(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    // If a search query is active, use the search results; otherwise, show the full list.
    final bool isSearching = _searchQuery.isNotEmpty;
    final List displayedCategories = isSearching
        ? categoryViewModel.searchResults
        : categoryViewModel.categories;

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluegray,
        title: Center(child: Text("ALL CATEGORIES", style: TextStyle(color: white))),
      ),
      drawer:isDesktop
          ? null :CustomDrawer(onLogout: () => authViewModel.logout(),),
      body: Row(
        children: [
          //Drawer for desktop
          isDesktop
              ? CustomDrawer(
                  onLogout: () => authViewModel.logout(),
                )
              : SizedBox(),
          categoryViewModel.isLoading && categoryViewModel.categories.isEmpty
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: Container(
                    color: bluegray50,
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
                              fillColor: white,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Category List
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: displayedCategories.length,
                              itemBuilder: (context, index) {
                                final category = displayedCategories[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(
                                      category["name"] ??
                                          category["categoryName"] ??
                                          "",
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
                                              context.push(
                                                  '/categories/update/${category["id"]}');
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: red),
                                            onPressed: () async {
                                              final id = category["id"] ?? "";
                                              await categoryViewModel
                                                  .deleteCategory(id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Category deleted successfully")),
                                              );
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
                          // Optional: A loader at the bottom when loading more data.
                          if (categoryViewModel.isLoading &&
                              categoryViewModel.categories.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
