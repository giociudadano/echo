import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Signup Page', style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 48,
              )),
            ],
          ),
        ),
      ),
    );
  }
}