import 'package:admin_panel/core/network/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart'; // Import the ApiClient

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _token; // Store token

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  AuthViewModel() {
    _loadToken(); // Load token on ViewModel initialization
  }

  // ✅ Load token from SharedPreferences when app starts
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("auth_token");
    print("🔹 Loaded Token: $_token");
    notifyListeners();
  }

  // ✅ Save token in SharedPreferences
  Future<void> _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
    print("✅ Token Saved: $token");
  }

  // ✅ Login method using Dio from ApiClient
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Dio dio = await ApiClient.getDio(); // Use Dio from ApiClient
      Response response = await dio.post(
        ApiEndpoints.login, // Adjust endpoint as needed
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data["accessToken"] != null) {
        _token = response.data["accessToken"];
        print("🔹 Loaded Token: $_token");
        await _saveToken(_token); // Save token after login
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data["message"] ?? "Login failed";
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ✅ Logout function to clear token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token"); // Remove token on logout
    _token = null;
    notifyListeners();
  }
}
