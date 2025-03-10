import 'package:admin_panel/constants/button.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
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
    // final bool isSearching = _searchQuery.isNotEmpty;
    // final List displayedCategories = isSearching
    //     ? categoryViewModel.searchResults
    //     : categoryViewModel.categories;

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
            Text("Category Screen", style: TextStyle(color: white)),
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
          categoryViewModel.isLoading && categoryViewModel.categories.isEmpty
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
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
                                "All Categories",
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
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            controller: _searchController,
                                            onChanged: (value) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                setState(() {
                                                  _searchQuery = value;
                                                });
                                                if (value.isEmpty) {
                                                  categoryViewModel
                                                      .clearSearch();
                                                } else {
                                                  categoryViewModel
                                                      .searchCategories(value);
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Search Categories",
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
                                        SizedBox(
                                            width:
                                                200, // Set fixed width for the button
                                            height:
                                                50, // Optional: Set fixed height
                                            child: CustomButton(
                                              text: "Add Categories",
                                              route: "/categories/add",
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
                                        TextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                _searchQuery = value;
                                              });
                                              if (value.isEmpty) {
                                                categoryViewModel.clearSearch();
                                              } else {
                                                categoryViewModel
                                                    .searchCategories(value);
                                              }
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Search Categories",
                                            prefixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            filled: true,
                                            fillColor: white,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(
                                            width:
                                                200, // Set fixed width for the button
                                            height:
                                                50, // Optional: Set fixed height
                                            child: CustomButton(
                                              text: "Add Categories",
                                              route: "/categories/add",
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              borderRadius: 8.0,
                                            )),
                                      ],
                                    ),
                              SizedBox(height: 20),
                              // Category List
                              Expanded(
                                child: Consumer<CategoryViewModel>(
                                  builder: (context, categoryViewModel, child) {
                                    final bool isSearching =
                                        _searchQuery.isNotEmpty;
                                    final List displayedCategories = isSearching
                                        ? categoryViewModel.searchResults
                                        : categoryViewModel.categories;

                                    if (categoryViewModel.isLoading &&
                                        displayedCategories.isEmpty) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }

                                    return ListView.builder(
                                      controller: _scrollController,
                                      itemCount: displayedCategories.length,
                                      itemBuilder: (context, index) {
                                        final category =
                                            displayedCategories[index];
                                        return Card(
                                          color: bluegray50,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                      final id =
                                                          category["id"] ?? "";
                                                      await categoryViewModel
                                                          .deleteCategory(id);
                                                      ScaffoldMessenger.of(
                                                              context)
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
