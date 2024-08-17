import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPerformanceScreen extends StatelessWidget {
  final String studentId;

  StudentPerformanceScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Performance')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('performance')
            .where('studentId', isEqualTo: studentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final performances = snapshot.data!.docs;

          return ListView.builder(
            itemCount: performances.length,
            itemBuilder: (context, index) {
              var performance = performances[index];
              return ListTile(
                title: Text(performance['task']),
                subtitle: Text('Score: ${performance['score']}'),
              );
            },
          );
        },
      ),
    );
  }
}
