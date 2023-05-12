part of main;

class SignupPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inputEmail = TextEditingController();
  final _inputUsername = TextEditingController();
  final _inputPassword = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(98, 112, 243, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      'Nice to\nmeet you!',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 50,
                          height: 0.85,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _inputEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                        validator: (String? value) {
                          return _verifyEmail(value);
                        },
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Username",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _inputUsername,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Enter your username',
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                        validator: (String? value) {
                          return _verifyUsername(value);
                        },
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _inputPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                        validator: (String? value) {
                          return _verifyPassword(value);
                        },
                      ),
                      SizedBox(height: 60),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.black),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ))),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _addUser(context, _inputEmail.text,
                                      _inputUsername.text, _inputPassword.text);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Color.fromRGBO(235, 235, 235, 0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'I already have an account',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  _verifyUsername(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    } else if (value.length < 3) {
      return 'Please enter 3 characters or more';
    }
    return null;
  }

  _verifyPassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Please enter 8 characters or more';
    }
    return null;
  }

  _addUser(BuildContext context, email, username, password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Account has been created!"),
      ));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              "Email already exists, please try logging in using this email.";
          break;
        case 'invalid-email':
          errorMessage = "Please enter a valid email address.";
          break;
        default:
          errorMessage =
              "There was an unknown error with creating your account. Please try again later.";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an unknown error with authenticating to servers. Please try again later."),
      ));
      return;
    }
    String userID;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userID = user.uid;
        DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userID");
        ref.update({
          "username": _generateUsername(username),
          "displayName": username,
        });
      }
    });
    Navigator.pop(context);
    LoginPage().loginUser(context, email, password);
  }

  _generateUsername(username) {
    while (true) {
      bool isDuplicate = false;
      final String randomInt =
          Random().nextInt(9999).toString().padLeft(4, '0');
      var newUsername = "$username#$randomInt";
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("Users");
      ref.orderByChild("username").equalTo(newUsername).get().then((value) => {
            if (value.exists) {isDuplicate = true}
          });
      if (!isDuplicate) {
        return newUsername;
      }
    }
  }
}
