import 'package:flutter/material.dart';
import '../services/exam_service.dart';

class ExamViewModel extends ChangeNotifier {
  final ExamService _examService = ExamService();

  List<Map<String, String>> _exams = [];
  List<Map<String, String>> buttonData = [];
  List<Map<String, String>> admitCardExamList = [];
  List<Map<String, String>> resultExamList = [];
  List<Map<String, String>> answerKeyExamList = [];
  List<Map<String, String>> syllabusExamList = [];
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? selectedExam; // Holds the fetched exam details

  String? _errorMessage;

  List<Map<String, dynamic>> get searchResults => _searchResults;
  String? get errorMessage => _errorMessage;

  bool isLoadingMore = false;

  List<Map<String, String>> get exams => _exams;
  bool isLoading = false;
  int page = 1;
  int limit = 20;
  int totalPages = 1;

  ExamViewModel() {
    fetchAllData();
  }

  /// Fetch all exam data in one go
  Future<void> fetchAllData() async {
    _setLoading(true);
    try {
      await Future.wait([
        fetchExams(),
        fetchExamDataByLastdate(),
        fetchExamsByAdmitCard(),
        fetchExamsByResult(),
        fetchExamsByAnswerKey(),
        fetchExamsBySyllabus(),
      ]);
    } catch (e) {
      _errorMessage = "Error fetching data: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch all exams with pagination
  Future<void> fetchExams({bool isLoadMore = false}) async {
    if (isLoadMore && (isLoadingMore || page > totalPages)) return;

    try {
      if (isLoadMore) {
        isLoadingMore = true;
      } else {
        isLoading = true;
      }
      notifyListeners();

      Map<String, dynamic> data = await _examService.fetchExams(page, limit);

      List<Map<String, String>> fetchedExams = data["exams"]
          .where((exam) => exam["_id"] != null && exam["name"] != null)
          .map<Map<String, String>>((exam) {
        String categoryId = "";
        if (exam["examCategory"] != null) {
          categoryId = exam["examCategory"] is Map
              ? exam["examCategory"]["_id"].toString()
              : exam["examCategory"].toString();
        }
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
          "examcategory": categoryId,
        };
      }).toList();

      if (isLoadMore) {
        _exams.addAll(fetchedExams);
      } else {
        _exams = fetchedExams;
      }
      totalPages = data["totalPages"];

      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
      print("Error fetching exams: $e");
    }
  }

  // Method to update an exam in the local list
  void updateExamLocally(String examId, Map<String, String> updatedExam) {
    int index = _exams.indexWhere((exam) => exam["id"] == examId);
    if (index != -1) {
      _exams[index] = updatedExam;
      notifyListeners();
    }
  }

  /// 🔹 Search Exams by Name
  Future<void> searchExams(String query) async {
    if (query.isEmpty) return;

    _setLoading(true);
    _errorMessage = null;
    try {
      _searchResults = await _examService.searchExamsByName(query);
    } catch (e) {
      _errorMessage = "Failed to fetch search results: $e";
      _searchResults = [];
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Clear Search Results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// 🔹 Fetch Single Exam by Name
  Future<void> fetchExamByName(String name) async {
    _setLoading(true);
    try {
      selectedExam = await _examService.getExamByName(name);
    } catch (e) {
      _errorMessage = "Error fetching exam: $e";
      selectedExam = null;
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Add a New Exam
  Future<void> addExam(Map<String, dynamic> examData) async {
    try {
      await _examService.addExam(examData);
      await fetchExams(); // Refresh list after adding
    } catch (e) {
      _errorMessage = "Error adding exam: $e";
    }
  }

  /// 🔹 Update an Exam
  Future<void> updateExam(String id, Map<String, dynamic> updatedData) async {
    try {
      await _examService.updateExam(id, updatedData);
      await fetchExams(); // Refresh list after updating
    } catch (e) {
      _errorMessage = "Error updating exam: $e";
    }
  }

  /// 🔹 Delete an Exam
  Future<bool> deleteExam(String id) async {
    try {
      await _examService.deleteExam(id);
      exams.removeWhere((exam) => exam['id'] == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "Error deleting exam: $e";
      return false;
    }
  }

  /// 🔹 Fetch Exams by Last Date to Apply
  Future<void> fetchExamDataByLastdate() async {
    _setLoading(true);
    try {
      var data = await _examService.getExamsByLastDateToApply(page, 9);
      buttonData = List<Map<String, String>>.from(
        data["exams"].map((exam) => {
              "id": exam["_id"].toString(),
              "name": exam["name"].toString(),
            }),
      );
      totalPages = data["totalPages"];
    } catch (e) {
      _errorMessage = "Error fetching exams by last date: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Fetch Exams where Admit Card is Available
  Future<void> fetchExamsByAdmitCard() async {
    _setLoading(true);
    try {
      var data = await _examService.getExamsByAdmitCard(page, limit);
      admitCardExamList = List<Map<String, String>>.from(
        data["exams"].map((exam) => {
              "id": exam["_id"].toString(),
              "name": exam["name"].toString(),
            }),
      );
      totalPages = data["totalPages"];
    } catch (e) {
      _errorMessage = "Error fetching admit card exams: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Fetch Exams where Result is Available
  Future<void> fetchExamsByResult() async {
    _setLoading(true);
    try {
      var data = await _examService.getExamsByResult(page, limit);
      resultExamList = List<Map<String, String>>.from(
        data["exams"].map((exam) => {
              "id": exam["_id"].toString(),
              "name": exam["name"].toString(),
            }),
      );
      totalPages = data["totalPages"];
    } catch (e) {
      _errorMessage = "Error fetching result exams: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Fetch Exams where Answer Key is Available
  Future<void> fetchExamsByAnswerKey() async {
    _setLoading(true);
    try {
      var data = await _examService.getExamsByAnswerKey(page, limit);
      answerKeyExamList = List<Map<String, String>>.from(
        data["exams"].map((exam) => {
              "id": exam["_id"].toString(),
              "name": exam["name"].toString(),
            }),
      );
      totalPages = data["totalPages"];
    } catch (e) {
      _errorMessage = "Error fetching answer key exams: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Fetch Exams where Syllabus is Available
  Future<void> fetchExamsBySyllabus() async {
    _setLoading(true);
    try {
      var data = await _examService.getExamsBySyllabus(page, limit);
      syllabusExamList = List<Map<String, String>>.from(
        data["exams"].map((exam) => {
              "id": exam["_id"].toString(),
              "name": exam["name"].toString(),
            }),
      );
      totalPages = data["totalPages"];
    } catch (e) {
      _errorMessage = "Error fetching syllabus exams: $e";
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Set Loading State
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
