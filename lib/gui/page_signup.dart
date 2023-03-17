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
                        controller: _inputUsername,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Enter your username',
                        ),
                        validator: (String? value) {
                          return _verifyUsername(value);
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
                                _addUser(context, _inputEmail.text, _inputUsername.text, _inputPassword.text);
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
      switch (e.code){
        case 'email-already-in-use':
          errorMessage = "Email already exists, please try logging in using this email.";
          break;
        case 'invalid-email':
          errorMessage = "Please enter a valid email address.";
          break;
        default:
          errorMessage = "There was an unknown error with creating your account. Please try again later.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was an unknown error with authenticating to servers. Please try again later."),
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
        });
      }
    });
    Navigator.pop(context);
    LoginPage().loginUser(context, email, password);
  }

  _generateUsername(username) {
    while (true) {
      bool isDuplicate = false;
      final String randomInt = Random().nextInt(9999).toString().padLeft(4, '0');
      var newUsername = "$username#$randomInt";
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("Users");
      ref.orderByChild("username").equalTo(newUsername).get().then((value) => {
        if (value.exists){
          isDuplicate = true
        }
      });
      if (!isDuplicate) {
        return newUsername;
      }
    }
  }
}