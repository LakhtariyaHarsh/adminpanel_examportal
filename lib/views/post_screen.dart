import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:admin_panel/views/add_post.dart';
import 'package:admin_panel/views/update_post.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 156, 160),
        title: Text("POSTS", style: TextStyle(color: Colors.white)),
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
                      onPressed: () {
                        context.go('/categories');
                      },
                      child: Text("Category",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/eligibilities');
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
                            onTap: () {
                              context.go('/posts');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.verified_user,
                                color: Colors.blueGrey),
                            title: const Text("Eligibility"),
                            onTap: () {
                              context.go('/eligibilities');
                            },
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
          context.push(
            '/posts/add', // Passing ViewModel manually
          );
        },
        child: Icon(Icons.add),
      ),
      body: postViewModel.isLoading && postViewModel.posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: screenWidth >= 1024
                    ? screenWidth * 0.7
                    : screenWidth * 0.95,
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
                          fillColor: Colors.white,
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
                                            color: Colors.blue),
                                        onPressed: () {
                                          GoRouter.of(context).push(
                                            '/posts/update/${post["id"]}?postName=${Uri.encodeComponent(post["name"] ?? "")}&eligibilityid=${post["eligiblityDetails"] ?? ""}',
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final id = post["id"] ?? "";
                                          await postViewModel.deletePost(id);
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
    );
  }
}
