import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';

class ExamService {
  // Fetch all exams with pagination
  Future<Map<String, dynamic>> fetchExams(int page, int limit) async {
    return _fetchExams(ApiEndpoints.exams, page, limit);
  }

  // Fetch exams based on last date to apply
  Future<Map<String, dynamic>> getExamsByLastDateToApply(
      int page, int limit) async {
    return _fetchExams(
        "/exams/lastDateToApply", page, limit, {"sort": "lastDateToApply"});
  }

  // Fetch exams where admit card is available
  Future<Map<String, dynamic>> getExamsByAdmitCard(int page, int limit) async {
    return _fetchExams("/exams/admit-card", page, limit,
        {"isAdmitCardAvailable": true, "sort": "admitCardAvailable"});
  }

  // Fetch exams where result is available
  Future<Map<String, dynamic>> getExamsByResult(int page, int limit) async {
    return _fetchExams("/exams/result", page, limit,
        {"resultAvailable": true, "sort": "resultPostingDate"});
  }

  // Fetch exams with syllabus available
  Future<Map<String, dynamic>> getExamsBySyllabus(int page, int limit) async {
    return _fetchExams("/exams/syllabus", page, limit,
        {"syllabusAvailable": true, "sort": "syllabusAvailableDate"});
  }

  // Fetch exams with answer key available
  Future<Map<String, dynamic>> getExamsByAnswerKey(int page, int limit) async {
    return _fetchExams("/exams/answerkey", page, limit,
        {"isAnswerKeyAvailable": true, "sort": "answerKeyAvailable"});
  }

  // Fetch single exam by name
  Future<Map<String, dynamic>> getExamByName(String examName) async {
    try {
      Dio dio = await ApiClient.getDio();
      Response response = await dio.get("/exams/$examName");
      return response.data;
    } catch (e) {
      print("Fetch Exam by Name Error: $e");
      throw Exception("Failed to load exam details: $e");
    }
  }

  // Fetch Exams Helper Method
  Future<Map<String, dynamic>> _fetchExams(String endpoint, int page, int limit,
      [Map<String, dynamic>? additionalParams]) async {
    try {
      Dio dio = await ApiClient.getDio();
      Map<String, dynamic> queryParams = {"page": page, "limit": limit};
      if (additionalParams != null) {
        queryParams.addAll(additionalParams);
      }

      Response response = await dio.get(endpoint, queryParameters: queryParams);
      return {
        "exams": List<Map<String, dynamic>>.from(response.data["exams"]),
        "totalPages": response.data["totalPages"]
      };
    } catch (e) {
      print("Fetch Exams Error: $e");
      throw Exception("Failed to load exams: $e");
    }
  }

  // Create a new exam
  Future<void> addExam(Map<String, dynamic> examData) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.post(ApiEndpoints.examscreate, data: examData);
    } catch (e) {
      print("Add Exam Error: $e");
      throw Exception("Failed to add exam: $e");
    }
  }

  // Update an existing exam
  Future<void> updateExam(String id, Map<String, dynamic> updatedData) async {
    try {
      Dio dio = await ApiClient.getDio();
      final response =
          await dio.put("${ApiEndpoints.examsupdate}/$id", data: updatedData);

      print("Update Exam Response: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        print("Exam updated successfully!");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized - Token may be expired");
      } else {
        throw Exception("Failed to update exam: ${response.statusMessage}");
      }
    } catch (e) {
      print("Update Exam Error: $e");
      throw Exception("Failed to update exam: $e");
    }
  }

  // Delete an exam
  Future<void> deleteExam(String id) async {
    try {
      Dio dio = await ApiClient.getDio();
      await dio.delete("${ApiEndpoints.examsdelete}/$id");
    } catch (e) {
      print("Delete Exam Error: $e");
      throw Exception("Failed to delete exam: $e");
    }
  }
}
