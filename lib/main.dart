import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/exam_view_model.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String initialRoute = await _getInitialRoute();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ExamViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel()),
        ChangeNotifierProvider(create: (_) => EligibilityViewModel()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

Future<String> _getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("auth_token");

  if (token != null && token.isNotEmpty) {
    return '/'; // Redirect to home if token exists
  } else {
    return '/login'; // Show login screen if not authenticated
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: getAppRouter(initialRoute), // ✅ Pass the dynamic initial route
    );
  }
}
