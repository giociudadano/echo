import 'package:bullet/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome!', style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 48,
              )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed: () {

                  }, child: Text('Log In'),),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  }, child: Text('Sign Up'),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}