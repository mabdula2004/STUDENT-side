import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_s/performance/StudentPerformanceScreen.dart';
import 'package:student_s/tasklist/TaskListScreen.dart';
import 'package:student_s/register/RegisterTeacherPage.dart' as register;
import 'package:student_s/course/CourseRegistrationForm.dart' as course;
import 'package:student_s/course/CourseRegistrationStatus.dart';
import 'package:student_s/homescreen/StudentHomeScreen.dart';
import 'package:student_s/login/LoginPage.dart';
import 'StudentInfoPage.dart';
import 'course/CourseRegistrationForm.dart'; // Import StudentInfoPage



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AuthWrapper(),
      routes: {
        '/studentHome': (context) => StudentHomeScreen(),
        '/courseStatus': (context) => CourseRegistrationStatus(),
        '/login': (context) => LoginPage(),
        '/tasklist': (context) => TaskListScreen(),
        '/performance': (context) => StudentPerformanceScreen(studentId: ''),
        '/registerCourse': (context) => CourseRegistrationForm(),
        '/studentInfo': (context) => StudentInfoPage(), // Add this route
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return StudentHomeScreen(); // User is logged in
        } else {
          return LoginPage(); // User is not logged in
        }
      },
    );
  }
}
