import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Future<Dio> getDio() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null || token.isEmpty) {
      print("⚠️ No token found in SharedPreferences. User may need to re-login.");
    } else {
      print("✅ Token Retrieved: $token");
    }

    BaseOptions options = BaseOptions(
      baseUrl: "http://localhost:4000/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        "Authorization": token != null ? "Bearer $token" : "",
        "Content-Type": "application/json",
      },
    );

    Dio dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("Request [${options.method}]: ${options.path}");
          print("Headers: ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("Response: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ API Error: ${e.response?.statusCode} - ${e.message}");
          print("Error Response: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
