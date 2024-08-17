import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentInfoPage extends StatefulWidget {
  @override
  _StudentInfoPageState createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailVerified = false;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _displayNameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      _emailVerified = user.emailVerified;
    }
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        bool shouldReload = false;

        if (user != null) {
          if (_displayNameController.text.isNotEmpty &&
              _displayNameController.text != user.displayName) {
            await user.updateDisplayName(_displayNameController.text);
            shouldReload = true;
          }

          if (_emailController.text.isNotEmpty &&
              _emailController.text != user.email) {
            await user.verifyBeforeUpdateEmail(_emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'A verification email has been sent to ${_emailController.text}. Please verify to complete the email update.'),
              ),
            );
            return; // Exit the method, as the email needs verification
          }

          if (_passwordController.text.isNotEmpty) {
            await user.updatePassword(_passwordController.text);
          }

          if (shouldReload) {
            await user.reload();
            user = FirebaseAuth.instance.currentUser;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully updated')),
          );

          Navigator.pop(context);  // Pop to the previous screen
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'requires-recent-login') {
          errorMessage =
          'Please re-authenticate and try again. Your session has expired.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (!_emailVerified)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Your email is not verified. Please verify your email to apply any changes.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value != null && value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text(
                  'Update Information',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
