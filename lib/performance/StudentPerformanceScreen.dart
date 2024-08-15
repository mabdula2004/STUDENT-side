import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPerformanceScreen extends StatelessWidget {
  final String studentId; // Assume this is passed when navigating to this screen

  StudentPerformanceScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('performance')
            .where('studentId', isEqualTo: studentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No performance data available'));
          }

          var performances = snapshot.data!.docs;

          return ListView.builder(
            itemCount: performances.length,
            itemBuilder: (context, index) {
              var performance = performances[index];
              return ListTile(
                title: Text('Task: ${performance['taskId']}'),
                subtitle: Text('Score: ${performance['score']}'),
              );
            },
          );
        },
      ),
    );
  }
}
