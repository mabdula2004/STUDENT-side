import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/register_student_page.dart';
import 'screens/login_page.dart';
import 'screens/student_home_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/student_performance_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StudentApp());
}

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/studentHome',
      routes: {
        '/login': (context) => LoginPage(),
        '/registerStudent': (context) => RegisterStudentPage(),
        '/studentHome': (context) => StudentHomeScreen(),
        '/tasks': (context) => TaskListScreen(),
        '/performance': (context) => StudentPerformanceScreen(studentId: ''),
      },
    );
  }
}
