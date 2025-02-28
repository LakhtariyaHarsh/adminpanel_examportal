import 'package:admin_panel/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_models/auth_view_model.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkToken(); // ✅ Check if user is already logged in
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token != null && token.isNotEmpty) {
      print("✅ Auto-login with token: $token");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isTablet = screenWidth < 1100;

    return Scaffold(
      body: Stack(children: <Widget>[
        // Fullscreen Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/webdesign.jpg', // Background image
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5), // Adjust overlay opacity
        ),
        Center(
          child: _isLoading
              ? CircularProgressIndicator() // ✅ Show loading indicator while checking token
              : SizedBox(
                  width: screenWidth >= 1024
                      ? screenWidth * 0.7
                      : screenWidth * 0.9,
                  child: Card(
                    color: bluegray100,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: isMobile
                              ? 20
                              : isTablet
                                  ? 50
                                  : 100,
                          horizontal: 20),
                      child: Row(
                        children: [
                          isMobile
                              ? SizedBox()
                              : Expanded(
                                  child:
                                      Image.asset("assets/images/login.png")),
                          SizedBox(
                            width: isMobile ? 0 : 20,
                          ),
                          Expanded(
                            child: Container(
                              color: white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock_outline,
                                        size: 80, color: black),
                                    SizedBox(height: 20),
                                    Text(
                                      "Admin Login",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 20),
                                    _buildTextField(emailController, "Email",
                                        Icons.email, false),
                                    SizedBox(height: 10),
                                    _buildTextField(passwordController,
                                        "Password", Icons.lock, true),
                                    SizedBox(height: 20),
                                    authViewModel.isLoading
                                        ? CircularProgressIndicator()
                                        : SizedBox(
                                            width: 200,
                                            child: ElevatedButton(
                                              onPressed: _handleLogin,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize:
                                                    const Size(130, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                ),
                                              ),
                                              child: Text("Login",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ]),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool isPassword) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: bluegrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: isPassword,
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
    );
  }

  void _handleLogin() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and Password cannot be empty")),
      );
      return;
    }

    bool success = await authViewModel.login(email, password);
    if (success) {
      context.go('/'); // ✅ Prevents multiple navigation calls
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.errorMessage ?? "Login Failed")),
      );
    }
  }
}
