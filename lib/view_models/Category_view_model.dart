import 'package:admin_panel/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService categoryService = CategoryService();

  List<Map<String, String>> categories = [];
  Map<String, dynamic>? selectedcategory; // Holds the fetched category details

  bool isLoading = false;
  int page = 1;
  int limit = 10;
  int totalPages = 1;

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

  /// Fetch all categorys with pagination
  Future<void> fetchcategorys() async {
    _setLoading(true);
    try {
      var data = await categoryService.fetchCategory(1, limit);
      categories = data["categories"].map<Map<String, String>>((category) {
        return {
          "id": category["_id"].toString(),
          "name": category["categoryName"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching categorys: $e");
    }
    _setLoading(false);
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

  /// Delete an category
  Future<void> deletecategory(String id) async {
    try {
      await categoryService.deleteCategory(id);
      categories.removeWhere((category) => category['id'] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting category: $e");
    }
  }


  /// Fetch a single category by name
  Future<Map<String, dynamic>?> fetchcategoryByName(String name) async {
    _setLoading(true);
    try {
      var data = await categoryService.getCategoryByName(name);
      selectedcategory = data; // Store the category data
      return data;
    } catch (e) {
      print("Error fetching category by name: $e");
      selectedcategory = null;
      return null;
    }
    _setLoading(false);
  }

  /// Set loading state and notify listeners
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
