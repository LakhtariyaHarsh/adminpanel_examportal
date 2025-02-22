import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';

class CategoryService {
  // Fetch all Category with pagination
  Future<Map<String, dynamic>> fetchCategory(int page, int limit) async {
    return _fetchCategory(ApiEndpoints.category, page, limit);
  }

  // Fetch single Category by name
  Future<Map<String, dynamic>> getCategoryByid(String categoryId) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response = await dio.get("/categories/categorybyid/$categoryId");
      return response.data;
    } catch (e) {
      print("Fetch Category by id Error: $e");
      throw Exception("Failed to load Category details: $e");
    }
  }

  // Fetch Category Helper Method
  Future<Map<String, dynamic>> _fetchCategory(
      String endpoint, int page, int limit,
      [Map<String, dynamic>? additionalParams]) async {
    try {
      Dio dio = await ApiClient.getDio();
      Map<String, dynamic> queryParams = {"page": page, "limit": limit};
      if (additionalParams != null) {
        queryParams.addAll(additionalParams);
      }

      Response response = await dio.get(endpoint, queryParameters: queryParams);
      return {
        "categories":
            List<Map<String, dynamic>>.from(response.data["categories"]),
        "totalPages": response.data["totalPages"]
      };
    } catch (e) {
      print("Fetch Category Error: $e");
      throw Exception("Failed to load Category: $e");
    }
  }

  // Fetch exams by search query (name)
  Future<List<Map<String, dynamic>>> searchCategoryByName(String query) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response =
          await dio.get("/categories/name", queryParameters: {"query": query});

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print("Search categories by Name Error: $e");
      throw Exception("Failed to search categories: $e");
    }
  }

  // Create a new Category
  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.post(ApiEndpoints.categorycreate, data: categoryData);
    } catch (e) {
      print("Add Category Error: $e");
      throw Exception("Failed to add Category: $e");
    }
  }

  // Update an existing Category
  Future<void> updateCategory(
      String id, Map<String, dynamic> updatedData) async {
    try {
      Dio dio = await ApiClient.getDio();
      final response = await dio.put("${ApiEndpoints.categoryupdate}/$id",
          data: updatedData);

      print("Update Category Response: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        print("Category updated successfully!");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized - Token may be expired");
      } else {
        throw Exception("Failed to update Category: ${response.statusMessage}");
      }
    } catch (e) {
      print("Update Category Error: $e");
      throw Exception("Failed to update Category: $e");
    }
  }

  // Delete an Category
  Future<void> deleteCategory(String id) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.delete("${ApiEndpoints.categorydelete}/$id");
    } catch (e) {
      print("Delete Category Error: $e");
      throw Exception("Failed to delete Category: $e");
    }
  }
}
