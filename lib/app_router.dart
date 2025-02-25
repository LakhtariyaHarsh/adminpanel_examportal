import 'package:admin_panel/views/add_category.dart';
import 'package:admin_panel/views/add_eligibility.dart';
import 'package:admin_panel/views/add_exam_screen.dart';
import 'package:admin_panel/views/add_post.dart';
import 'package:admin_panel/views/admin_dashboard.dart';
import 'package:admin_panel/views/category.dart';
import 'package:admin_panel/views/eligibility_screen.dart';
import 'package:admin_panel/views/login_screen.dart';
import 'package:admin_panel/views/post_screen.dart';
import 'package:admin_panel/views/update_category.dart';
import 'package:admin_panel/views/update_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter getAppRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute, // ✅ Dynamically set initial route
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) => MaterialPage(child: AdminDashboard()),
      ),
      GoRoute(
        name: 'category',
        path: '/categories',
        pageBuilder: (context, state) => MaterialPage(child: Category()),
      ),
      GoRoute(
        name: 'post',
        path: '/posts',
        pageBuilder: (context, state) => MaterialPage(child: PostScreen()),
      ),
      GoRoute(
        name: 'eligibility',
        path: '/eligibilities',
        pageBuilder: (context, state) => MaterialPage(child: EligibilityScreen()),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        name: 'addexam',
        path: '/exams/add',
        pageBuilder: (context, state) => MaterialPage(child: AddExamScreen()),
      ),
      GoRoute(
        name: 'update-exam',
        path: '/exams/update/:examId/:examName/:categoryId',
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          final examName = Uri.decodeComponent(state.pathParameters['examName']!);
          final categoryId = state.pathParameters['categoryId']!;
          return UpdateExamScreen(id: examId, examName: examName, categoryid: categoryId);
        },
      ),
      GoRoute(
        name: 'addcategory',
        path: '/categories/add',
        pageBuilder: (context, state) => MaterialPage(child: AddCategoryScreen()),
      ),
      GoRoute(
        name: 'updatecategory',
        path: '/categories/update/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return UpdateCategory(id: categoryId);
        },
      ),
       GoRoute(
        name: 'addpost',
        path: '/posts/add',
        pageBuilder: (context, state) => MaterialPage(child: AddPostScreen()),
      ),
       GoRoute(
        name: 'addeligibility',
        path: '/eligibilities/add',
        pageBuilder: (context, state) => MaterialPage(child: AddEligibility()),
      ),
    ],
  );
}
