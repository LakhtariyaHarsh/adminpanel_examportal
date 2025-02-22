import 'package:admin_panel/views/add_category.dart';
import 'package:admin_panel/views/add_exam_screen.dart';
import 'package:admin_panel/views/admin_dashboard.dart';
import 'package:admin_panel/views/category.dart';
import 'package:admin_panel/views/login_screen.dart';
import 'package:admin_panel/views/update_category.dart';
import 'package:admin_panel/views/update_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

  GoRouter router = GoRouter(
     initialLocation: '/login',
      routes: [
        GoRoute(
            name: 'Exams',
            path: '/',
            pageBuilder: (context, state){
              return MaterialPage(child: AdminDashboard());
            }
        ),
        GoRoute(
            name: 'category',
            path: '/categories',
            pageBuilder: (context, state){
              return MaterialPage(child: Category());
            }
        ),
        GoRoute(
            name: 'login',
            path: '/login',
            pageBuilder: (context, state){
              return MaterialPage(child: LoginScreen());
            }
        ),
        GoRoute(
            name: 'addexam',
            path: '/exams/add',
            pageBuilder: (context, state){
              return MaterialPage(child: AddExamScreen());
            }
        ),
         GoRoute(
            name: 'update-exam',
            path: '/exams/update',
            pageBuilder: (context, state){  
              final examId = Uri.decodeComponent(state.pathParameters['examId']!);
              final categoryid = Uri.decodeComponent(state.pathParameters['categoryid']!);
              final examName = Uri.decodeComponent(state.pathParameters['examName']!);
              return MaterialPage(child: UpdateExamScreen(id: examId, examName: examName, categoryid: categoryid));
            }
        ),
        GoRoute(
            name: 'addcategory',
            path: '/categories/add',
            pageBuilder: (context, state){
              return MaterialPage(child: AddCategoryScreen());
            }
        ),
        GoRoute(
            name: 'updatecategory',
            path: '/categories/update',
            pageBuilder: (context, state){
              final categoryId = Uri.decodeComponent(state.pathParameters['categoryId']!);
              return MaterialPage(child: UpdateCategory(id: categoryId));
            }
        ),

      ]

  );
