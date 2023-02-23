import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignupPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inputEmail = TextEditingController();
  final _inputPassword = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Signup Page',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 48,)
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextFormField(
                        controller: _inputEmail,
                        decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        ),
                        validator: (String? value) {
                          return _verifyEmail(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextFormField(
                        controller: _inputPassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                        validator: (String? value) {
                          return _verifyPassword(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _addUser(context);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Back'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _verifyEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    return null;
  }

  _verifyPassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  _addUser(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _inputEmail.text,
        password: _inputPassword.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Account has been created!"),
      ));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code){
        case 'weak-password':
          errorMessage = "Password is too weak, please enter at least 6 characters.";
          break;
        case 'email-already-in-use':
          errorMessage = "Email already exists, please try logging in using this email.";
          break;
        default:
          errorMessage = "There was an unknown error with creating your account. Please try again later.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$errorMessage')));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was an unknown error with authenticating to servers. Please try again later."),
      ));
      return;
    };
  }
}