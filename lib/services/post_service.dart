import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';

class PostService {
  // Fetch all Post with pagination
  Future<Map<String, dynamic>> fetchPost(int page, int limit) async {
    return _fetchPost(ApiEndpoints.post, page, limit);
  }

  // Fetch single Post by name
  Future<Map<String, dynamic>> getPostByid(String PostId) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response = await dio.get("/posts/postByid/$PostId");
      return response.data;
    } catch (e) {
      print("Fetch Post by id Error: $e");
      throw Exception("Failed to load Post details: $e");
    }
  }

  // Fetch Post Helper Method
  Future<Map<String, dynamic>> _fetchPost(
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
        "posts":
            List<Map<String, dynamic>>.from(response.data["posts"]),
        "totalPages": response.data["totalPages"]
      };
    } catch (e) {
      print("Fetch Post Error: $e");
      throw Exception("Failed to load Post: $e");
    }
  }

  // Fetch exams by search query (name)
  Future<List<Map<String, dynamic>>> searchPostByName(String query) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response =
          await dio.get("/posts/name", queryParameters: {"query": query});

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print("Search posts by Name Error: $e");
      throw Exception("Failed to search posts: $e");
    }
  }

  // Create a new Post
  Future<void> addPost(Map<String, dynamic> PostData) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.post(ApiEndpoints.postcreate, data: PostData);
    } catch (e) {
      print("Add Post Error: $e");
      throw Exception("Failed to add Post: $e");
    }
  }

  // Update an existing Post
  Future<void> updatePost(
      String id, Map<String, dynamic> updatedData) async {
    try {
      Dio dio = await ApiClient.getDio();
      final response = await dio.put("${ApiEndpoints.postupdate}/$id",
          data: updatedData);

      print("Update Post Response: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        print("Post updated successfully!");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized - Token may be expired");
      } else {
        throw Exception("Failed to update Post: ${response.statusMessage}");
      }
    } catch (e) {
      print("Update Post Error: $e");
      throw Exception("Failed to update Post: $e");
    }
  }

  // Delete an Post
  Future<void> deletePost(String id) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.delete("${ApiEndpoints.postdelete}/$id");
    } catch (e) {
      print("Delete Post Error: $e");
      throw Exception("Failed to delete Post: $e");
    }
  }
}
