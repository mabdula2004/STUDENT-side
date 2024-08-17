import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseRegistrationStatus extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Registration Status')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('courseRegistrationRequests')
            .where('studentId', isEqualTo: _auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];

              return ListTile(
                title: Text(request['course']),
                subtitle: Text('Status: ${request['status']}'),
                trailing: request['status'] == 'Approved' ?
                Text('Course ID: ${request['courseId']}') :
                null,
              );
            },
          );
        },
      ),
    );
  }
}
