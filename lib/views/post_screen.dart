import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    // Fetch initial categories.
    postViewModel.fetchPosts();
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
      final postViewModel = Provider.of<PostViewModel>(context, listen: false);
      // If not loading and more pages exist, fetch more.
      if (!postViewModel.isLoading &&
          postViewModel.page < postViewModel.totalPages) {
        postViewModel.fetchPosts(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final postViewModel = Provider.of<PostViewModel>(context);
    // If a search query is active, use the search results; otherwise, show the full list.
    final bool isSearching = _searchQuery.isNotEmpty;
    final List displayedPosts =
        isSearching ? postViewModel.searchResults : postViewModel.posts;

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluegray,
        title: Center(child: Text("ALL POSTS", style: TextStyle(color: white))),
      ),
      drawer: isDesktop
          ? null :CustomDrawer(onLogout: () => authViewModel.logout(),),
      body: Row(
        children: [
          //Drawer for desktop
          isDesktop
              ? CustomDrawer(onLogout: () => authViewModel.logout(),) : SizedBox(),
          postViewModel.isLoading && postViewModel.posts.isEmpty
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
                                postViewModel.clearSearch();
                              } else {
                                postViewModel.searchPosts(value);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Search posts",
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
                              itemCount: displayedPosts.length,
                              itemBuilder: (context, index) {
                                final post = displayedPosts[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(
                                      post["name"] ?? post["postName"] ?? "",
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
                                            onPressed: () {
                                              GoRouter.of(context).push(
                                                '/posts/update/${post["id"]}?postName=${Uri.encodeComponent(post["name"] ?? "")}&eligibilityid=${post["eligiblityDetails"] ?? ""}',
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: red),
                                            onPressed: () async {
                                              final id = post["id"] ?? "";
                                              await postViewModel
                                                  .deletePost(id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "post deleted successfully")),
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
                          if (postViewModel.isLoading &&
                              postViewModel.posts.isNotEmpty)
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
