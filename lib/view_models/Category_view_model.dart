import 'package:admin_panel/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService categoryService = CategoryService();

  List<Map<String, String>> categories = [];
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? selectedCategory; // Holds a single category’s details

  bool isLoading = false;
  String? errorMessage;
  int page = 1;
  int limit = 20; // Set a limit > 1 to have more than one item per page
  int totalPages = 1;

  List<Map<String, dynamic>> get searchResults => _searchResults;

  CategoryViewModel() {
    fetchAllData();
  }

  /// Fetch all category data (for now, simply call fetchCategories)
  Future<void> fetchAllData() async {
    _setLoading(true);
    try {
      await fetchCategories(); // loads first page
    } catch (e) {
      print("Error fetching all data: $e");
    }
    _setLoading(false);
  }

  /// Fetch categories with pagination.
  /// If isLoadMore is true, the new data is appended to the list.
  Future<void> fetchCategories({bool isLoadMore = false}) async {
    // If load-more is requested and we have already fetched all pages, return.
    if (isLoadMore && page >= totalPages) return;

    // If load-more, increment the page number; otherwise, use the current page (or reset page to 1)
    int fetchPage = isLoadMore ? page + 1 : 1;

    // If it's not a load more, clear the current list
    if (!isLoadMore) {
      categories = [];
      page = 1;
    }

    _setLoading(true);
    try {
      var data = await categoryService.fetchCategory(fetchPage, limit);
      List<Map<String, String>> fetchedCategories =
          data["categories"].map<Map<String, String>>((category) {
        return {
          "id": category["_id"].toString(),
          "name": category["categoryName"].toString(),
        };
      }).toList();

      totalPages = data["totalPages"];

      if (isLoadMore) {
        categories.addAll(fetchedCategories);
        page = fetchPage;
      } else {
        categories = fetchedCategories;
        page = fetchPage;
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    _setLoading(false);
  }

  /// Search categories by name.
  Future<void> searchCategories(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _setLoading(true);
    try {
      final response = await categoryService.searchCategoryByName(query);
      _searchResults = List<Map<String, dynamic>>.from(response);
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

  /// Add a new category and refresh the list.
  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    try {
      await categoryService.addCategory(categoryData);
      // Reset pagination and reload first page.
      page = 1;
      await fetchCategories();
    } catch (e) {
      print("Error adding category: $e");
    }
  }

  /// Update an existing category and refresh the list.
  Future<void> updateCategory(String id, Map<String, dynamic> updatedData) async {
    try {
      await categoryService.updateCategory(id, updatedData);
      page = 1;
      await fetchCategories();
    } catch (e) {
      print("Error updating category: $e");
    }
  }

  /// Delete a category and update the local list.
  Future<void> deleteCategory(String id) async {
    try {
      await categoryService.deleteCategory(id);
      // Remove the category locally so the UI updates immediately.
      categories.removeWhere((category) => category['id'] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting category: $e");
    }
  }

  /// Fetch a single category by ID.
  Future<Map<String, dynamic>?> fetchCategoryById(String id) async {
    _setLoading(true);
    try {
      var data = await categoryService.getCategoryByid(id);
      selectedCategory = data;
      return data;
    } catch (e) {
      print("Error fetching category by id: $e");
      selectedCategory = null;
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
