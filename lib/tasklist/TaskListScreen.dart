import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks available'));
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];

              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: Text('Due: ${task['dueDate']}'),
              );
            },
          );
        },
      ),
    );
  }
}
