
import 'package:admin_panel/services/eligibilities_service.dart';
import 'package:flutter/material.dart';

class EligibilityViewModel extends ChangeNotifier {
  final EligibilityService eligibilityService = EligibilityService();

  List<Map<String, String>> eligibilities = [];
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? selectedEligibility; // Holds a single Eligibility’s details

  bool isLoading = false;
  String? errorMessage;
  int page = 1;
  int limit = 20; // Set a limit > 1 to have more than one item per page
  int totalPages = 1;

  List<Map<String, dynamic>> get searchResults => _searchResults;

  EligibilityViewModel() {
    fetchAllData();
  }

  /// Fetch all Eligibility data (for now, simply call fetchCategories)
  Future<void> fetchAllData() async {
    _setLoading(true);
    try {
      await fetchEligibilities(); // loads first page
    } catch (e) {
      print("Error fetching all data: $e");
    }
    _setLoading(false);
  }

  /// Fetch fetchEligibilities with pagination.
  /// If isLoadMore is true, the new data is appended to the list.
  Future<void> fetchEligibilities({bool isLoadMore = false}) async {
    // If load-more is requested and we have already fetched all pages, return.
    if (isLoadMore && page >= totalPages) return;

    // If load-more, increment the page number; otherwise, use the current page (or reset page to 1)
    int fetchPage = isLoadMore ? page + 1 : 1;

    // If it's not a load more, clear the current list
    if (!isLoadMore) {
      eligibilities = [];
      page = 1;
    }

    _setLoading(true);
    try {
      var data = await eligibilityService.fetchEligibility(fetchPage, limit);
      List<Map<String, String>> fetchedEligibilities =
          data["eligibilities"].map<Map<String, String>>((eligibility) {
        return {
          "id": eligibility["_id"].toString(),
          "name": eligibility["eligiblityCriteria"].toString(),
        };
      }).toList();

      totalPages = data["totalPages"];

      if (isLoadMore) {
        eligibilities.addAll(fetchedEligibilities);
        page = fetchPage;
      } else {
        eligibilities = fetchedEligibilities;
        page = fetchPage;
      }
    } catch (e) {
      print("Error fetching eligibilities: $e");
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
      final response = await eligibilityService.searchEligibilityByName(query);
      // Map the search response to use the same keys.
      _searchResults =
          List<Map<String, dynamic>>.from(response).map((eligibility) {
        return {
          "id": eligibility["_id"].toString(),
          // Use "name" as the key, whether it comes as "name" or "EligibilityName"
          "name": eligibility["name"] ?? eligibility["eligiblityCriteria"] ?? "",
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

  /// Add a new Eligibility and refresh the list.
  Future<void> addEligibility(Map<String, dynamic> eligibilityData) async {
    try {
      await eligibilityService.addEligibility(eligibilityData);
      // Reset pagination and reload first page.
      page = 1;
      await fetchEligibilities();
    } catch (e) {
      print("Error adding Eligibility: $e");
    }
  }

  /// Update an existing Eligibility and refresh the list.
  Future<void> updateEligibility(
      String id, Map<String, dynamic> updatedData) async {
    try {
      await eligibilityService.updateEligibility(id, updatedData);
      page = 1;
      await fetchEligibilities();
    } catch (e) {
      print("Error updating Eligibility: $e");
    }
  }

  /// Delete a Eligibility and update the local list.
  Future<void> deleteEligibility(String id) async {
    try {
      await eligibilityService.deleteEligibility(id);
      // Remove the Eligibility locally so the UI updates immediately.
      eligibilities.removeWhere((eligibility) => eligibility['id'] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting Eligibility: $e");
    }
  }

  /// Fetch a single Eligibility by ID.
  Future<Map<String, dynamic>?> fetchEligibilityById(String id) async {
    _setLoading(true);
    try {
      var data = await eligibilityService.getEligibilityByid(id);
      selectedEligibility = data;
      return data;
    } catch (e) {
      print("Error fetching Eligibility by id: $e");
      selectedEligibility = null;
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
