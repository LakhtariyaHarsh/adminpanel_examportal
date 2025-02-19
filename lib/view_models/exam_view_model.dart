import 'package:flutter/material.dart';
import '../services/exam_service.dart';

class ExamViewModel extends ChangeNotifier {
  final ExamService examService = ExamService();

  List<Map<String, String>> exams = [];
  List<Map<String, String>> buttonData = [];
  List<Map<String, String>> admitCardExamList = [];
  List<Map<String, String>> resultExamList = [];
  List<Map<String, String>> answerKeyExamList = [];
  List<Map<String, String>> syllabusExamList = [];
  Map<String, dynamic>? selectedExam; // Holds the fetched exam details

  bool isLoading = false;
  int page = 1;
  int limit = 10;
  int totalPages = 1;

  ExamViewModel() {
    fetchAllData();
  }

  /// Fetch all exam data in one go
  Future<void> fetchAllData() async {
    _setLoading(true);
    try {
      await fetchExams();
      await fetchExamDataByLastdate();
      await fetchExamsByAdmitCard();
      await fetchExamsByResult();
      await fetchExamsByAnswerKey();
      await fetchExamsBySyllabus();
    } catch (e) {
      print("Error fetching all data: $e");
    }
    _setLoading(false);
  }

  /// Fetch all exams with pagination
  Future<void> fetchExams() async {
    _setLoading(true);
    try {
      var data = await examService.fetchExams(1, limit);
      exams = data["exams"].map<Map<String, String>>((exam) {
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching exams: $e");
    }
    _setLoading(false);
  }

  /// Add a new exam
  Future<void> addExam(Map<String, dynamic> examData) async {
    try {
      await examService.addExam(examData);
      await fetchExams(); // Refresh list after adding
    } catch (e) {
      print("Error adding exam: $e");
    }
  }

  /// Update an existing exam
  Future<void> updateExam(String id, Map<String, dynamic> updatedData) async {
    try {
      await examService.updateExam(id, updatedData);
      await fetchExams(); // Refresh list after updating
    } catch (e) {
      print("Error updating exam: $e");
    }
  }

  /// Delete an exam
  Future<void> deleteExam(String id) async {
    try {
      await examService.deleteExam(id);
      exams.removeWhere((exam) => exam['id'] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting exam: $e");
    }
  }

  /// Fetch exams sorted by last date to apply
  Future<void> fetchExamDataByLastdate() async {
    _setLoading(true);
    try {
      var data = await examService.getExamsByLastDateToApply(page, 9);
      buttonData = data["exams"].map<Map<String, String>>((exam) {
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching exams by last date: $e");
    }
    _setLoading(false);
  }

  /// Fetch exams where admit card is available
  Future<void> fetchExamsByAdmitCard() async {
    _setLoading(true);
    try {
      var data = await examService.getExamsByAdmitCard(page, limit);
      admitCardExamList = data["exams"].map<Map<String, String>>((exam) {
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching exams by admit card: $e");
    }
    _setLoading(false);
  }

  /// Fetch exams where result is available
  Future<void> fetchExamsByResult() async {
    _setLoading(true);
    try {
      var data = await examService.getExamsByResult(page, limit);
      resultExamList = data["exams"].map<Map<String, String>>((exam) {
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching exams by result: $e");
    }
    _setLoading(false);
  }

  /// Fetch exams where answer key is available
  Future<void> fetchExamsByAnswerKey() async {
    _setLoading(true);
    try {
      var data = await examService.getExamsByAnswerKey(page, limit);
      answerKeyExamList = data["exams"].map<Map<String, String>>((exam) {
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching exams by answer key: $e");
    }
    _setLoading(false);
  }

  /// Fetch exams where syllabus is available
  Future<void> fetchExamsBySyllabus() async {
    _setLoading(true);
    try {
      var data = await examService.getExamsBySyllabus(page, limit);
      syllabusExamList = data["exams"].map<Map<String, String>>((exam) {
        return {
          "id": exam["_id"].toString(),
          "name": exam["name"].toString(),
        };
      }).toList();
      totalPages = data["totalPages"];
    } catch (e) {
      print("Error fetching exams by syllabus: $e");
    }
    _setLoading(false);
  }

  /// Fetch a single exam by name
  Future<Map<String, dynamic>?> fetchExamByName(String name) async {
    _setLoading(true);
    try {
      var data = await examService.getExamByName(name);
      selectedExam = data; // Store the exam data
      return data;
    } catch (e) {
      print("Error fetching exam by name: $e");
      selectedExam = null;
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
