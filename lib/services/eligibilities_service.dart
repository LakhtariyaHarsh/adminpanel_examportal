import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';

class EligibilityService {
  // Fetch all Eligibility with pagination
  Future<Map<String, dynamic>> fetchEligibility(int page, int limit) async {
    return _fetchEligibility(ApiEndpoints.eligibility, page, limit);
  }

  // Fetch single Eligibility by name
  Future<Map<String, dynamic>> getEligibilityByid(String EligibilityId) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response = await dio.get("/eligibilities/eligibilityByid/$EligibilityId");
      return response.data;
    } catch (e) {
      print("Fetch Eligibility by id Error: $e");
      throw Exception("Failed to load Eligibility details: $e");
    }
  }

  // Fetch Eligibility Helper Method
  Future<Map<String, dynamic>> _fetchEligibility(
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
        "eligibilities":
            List<Map<String, dynamic>>.from(response.data["eligibilities"]),
        "totalPages": response.data["totalPages"]
      };
    } catch (e) {
      print("Fetch Eligibility Error: $e");
      throw Exception("Failed to load Eligibility: $e");
    }
  }

  // Fetch eligibilities by search query (name)
  Future<List<Map<String, dynamic>>> searchEligibilityByName(String query) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response =
          await dio.get("/eligibilities/name", queryParameters: {"query": query});

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print("Search eligibilities by Name Error: $e");
      throw Exception("Failed to search eligibilities: $e");
    }
  }

  // Create a new Eligibility
  Future<void> addEligibility(Map<String, dynamic> EligibilityData) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.post(ApiEndpoints.eligibilitycreate, data: EligibilityData);
    } catch (e) {
      print("Add Eligibility Error: $e");
      throw Exception("Failed to add Eligibility: $e");
    }
  }

  // Update an existing Eligibility
  Future<void> updateEligibility(
      String id, Map<String, dynamic> updatedData) async {
    try {
      Dio dio = await ApiClient.getDio();
      final response = await dio.put("${ApiEndpoints.eligibilityupdate}/$id",
          data: updatedData);

      print("Update Eligibility Response: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        print("Eligibility updated successfully!");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized - Token may be expired");
      } else {
        throw Exception("Failed to update Eligibility: ${response.statusMessage}");
      }
    } catch (e) {
      print("Update Eligibility Error: $e");
      throw Exception("Failed to update Eligibility: $e");
    }
  }

  // Delete an Eligibility
  Future<void> deleteEligibility(String id) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.delete("${ApiEndpoints.eligibilitydelete}/$id");
    } catch (e) {
      print("Delete Eligibility Error: $e");
      throw Exception("Failed to delete Eligibility: $e");
    }
  }
}
