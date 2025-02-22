import 'package:admin_panel/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService categoryService = CategoryService();

  List<Map<String, String>> categories = [];
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? selectedcategory; // Holds the fetched category details

  bool isLoading = false;
   String? errorMessage;
  int page = 1;
  int limit = 10;
  int totalPages = 1;

  List<Map<String, dynamic>> get searchResults => _searchResults;

  CategoryViewModel() {
    fetchAllData();
  }

  /// Fetch all category data in one go
  Future<void> fetchAllData() async {
    _setLoading(true);
    try {
      await fetchcategorys();
    } catch (e) {
      print("Error fetching all data: $e");
    }
    _setLoading(false);
  }

  /// Fetch all categories with pagination
  Future<void> fetchcategorys() async {
    _setLoading(true);
    try {
      var data = await categoryService.fetchCategory(page, limit);
      categories = data["categories"].map<Map<String, String>>((category) {
        return {
          "id": category["_id"].toString(),
          "name": category["categoryName"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching categories: $e");
    }
    _setLoading(false);
  }

  /// 🔹 Search Categories by Name
  Future<void> searchCategories(String query) async {
    if (query.isEmpty) {
      _searchResults = []; // Clear search results
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await categoryService.searchCategoryByName(query);
      _searchResults = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      errorMessage = "Failed to fetch search results";
      _searchResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// Add a new category
  Future<void> addcategory(Map<String, dynamic> categoryData) async {
    try {
      await categoryService.addCategory(categoryData);
      await fetchcategorys(); // Refresh list after adding
    } catch (e) {
      print("Error adding category: $e");
    }
  }

  /// Update an existing category
  Future<void> updatecategory(String id, Map<String, dynamic> updatedData) async {
    try {
      await categoryService.updateCategory(id, updatedData);
      await fetchcategorys(); // Refresh list after updating
    } catch (e) {
      print("Error updating category: $e");
    }
  }

  /// Delete a category
  Future<void> deletecategory(String id) async {
    try {
      await categoryService.deleteCategory(id);
      categories.removeWhere((category) => category['id'] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting category: $e");
    }
  }

  /// Fetch a single category by ID
  Future<Map<String, dynamic>?> fetchcategoryById(String id) async {
    _setLoading(true);
    try {
      var data = await categoryService.getCategoryByid(id);
      selectedcategory = data; // Store the category data
      return data;
    } catch (e) {
      print("Error fetching category by id: $e");
      selectedcategory = null;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
