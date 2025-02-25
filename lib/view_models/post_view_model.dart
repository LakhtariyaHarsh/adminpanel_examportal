import 'package:admin_panel/services/post_service.dart';
import 'package:flutter/material.dart';

class PostViewModel extends ChangeNotifier {
  final PostService postService = PostService();

  List<Map<String, String>> posts = [];
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? selectedpost; // Holds a single post’s details

  bool isLoading = false;
  String? errorMessage;
  int page = 1;
  int limit = 20; // Set a limit > 1 to have more than one item per page
  int totalPages = 1;

  List<Map<String, dynamic>> get searchResults => _searchResults;

  PostViewModel() {
    fetchAllData();
  }

  /// Fetch all post data (for now, simply call fetchCategories)
  Future<void> fetchAllData() async {
    _setLoading(true);
    try {
      await fetchPosts(); // loads first page
    } catch (e) {
      print("Error fetching all data: $e");
    }
    _setLoading(false);
  }

  /// Fetch categories with pagination.
  /// If isLoadMore is true, the new data is appended to the list.
  Future<void> fetchPosts({bool isLoadMore = false}) async {
    // If load-more is requested and we have already fetched all pages, return.
    if (isLoadMore && page >= totalPages) return;

    // If load-more, increment the page number; otherwise, use the current page (or reset page to 1)
    int fetchPage = isLoadMore ? page + 1 : 1;

    // If it's not a load more, clear the current list
    if (!isLoadMore) {
      posts = [];
      page = 1;
    }

    _setLoading(true);
    try {
      var data = await postService.fetchPost(fetchPage, limit);
      List<Map<String, String>> fetchedPosts =
          data["posts"].map<Map<String, String>>((post) {
        return {
          "id": post["_id"].toString(),
          "name": post["postName"].toString(),
        };
      }).toList();

      print(fetchedPosts.first);
      print("These is the fetched post..............................................................");

      totalPages = data["totalPages"];

      if (isLoadMore) {
        posts.addAll(fetchedPosts);
        page = fetchPage;
      } else {
        posts = fetchedPosts;
        page = fetchPage;
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
    _setLoading(false);
  }

  /// Search categories by name.
  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _setLoading(true);
    try {
      final response = await postService.searchPostByName(query);
      // Map the search response to use the same keys.
      _searchResults =
          List<Map<String, dynamic>>.from(response).map((post) {
        return {
          "id": post["_id"].toString(),
          // Use "name" as the key, whether it comes as "name" or "postName"
          "name": post["name"] ?? post["postName"] ?? "",
        };
      }).toList();
    } catch (e) {
      errorMessage = "Failed to fetch search results";
      _searchResults = [];
    }
    _setLoading(false);
  }

  /// Clear search results.
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// Add a new post and refresh the list.
  Future<void> addPost(Map<String, dynamic> postData) async {
    try {
      await postService.addPost(postData);
      // Reset pagination and reload first page.
      page = 1;
      await fetchPosts();
    } catch (e) {
      print("Error adding post: $e");
    }
  }

  /// Update an existing post and refresh the list.
  Future<void> updatePost(
      String id, Map<String, dynamic> updatedData) async {
    try {
      await postService.updatePost(id, updatedData);
      page = 1;
      await fetchPosts();
    } catch (e) {
      print("Error updating post: $e");
    }
  }

  /// Delete a post and update the local list.
  Future<void> deletePost(String id) async {
    try {
      await postService.deletePost(id);
      // Remove the post locally so the UI updates immediately.
      posts.removeWhere((post) => post['id'] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  /// Fetch a single post by ID.
  Future<Map<String, dynamic>?> fetchPostById(String id) async {
    _setLoading(true);
    try {
      var data = await postService.getPostByid(id);
      selectedpost = data;
      return data;
    } catch (e) {
      print("Error fetching post by id: $e");
      selectedpost = null;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Private method to set loading state.
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
