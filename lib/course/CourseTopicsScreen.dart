import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseTopicsScreen extends StatelessWidget {
  final String courseId;

  CourseTopicsScreen({required this.courseId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Topics'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('courses').doc(courseId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Course not found.'));
          }

          var courseData = snapshot.data!.data() as Map<String, dynamic>;
          var topics = courseData['topics'] as List<dynamic>?;

          if (topics == null || topics.isEmpty) {
            return Center(child: Text('No topics available for this course.'));
          }

          return ListView(
            children: topics.map((topic) {
              return ListTile(
                title: Text(topic.toString()), // Adjust this if topics have more details
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
