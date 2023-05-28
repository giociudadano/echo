part of main;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inputEmail = TextEditingController();
  final _inputPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Color.fromRGBO(98, 112, 243, 1),
            // Navigation bar
            statusBarColor: Color.fromRGBO(98, 112, 243, 1),
          )),
      backgroundColor: Color.fromRGBO(98, 112, 243, 1),
      body: SafeArea(
        child: Scrollbar(
            thickness: 10,
            child: Center(
              child: ListView(
                  children: [
                    SizedBox(height: 30),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(height: 270),
                        Positioned(
                          left: -120,
                          child: Image.asset(
                            'lib/assets/images/mascot_echo_flying.PNG',
                            height: 250,
                          ),
                        ),
                        Positioned(
                          left: 80,
                          top: 160,
                          child: Row(children: [
                            const Text(
                              'Welcome\nback',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 50,
                                  height: 0.85,
                                  color: Colors.white),
                            ),
                          ]),
                        )
                      ]
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                style:
                                TextStyle(color: Colors.white, fontSize: 14),
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
                              style: TextStyle(fontSize: 14),
                              validator: (String? value) {
                                return _verifyEmail(value);
                              },
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password",
                                style:
                                TextStyle(color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: _inputPassword,
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
                              style: TextStyle(fontSize: 14),
                              obscureText: true,
                            ),
                            SizedBox(height: 30),
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
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ))),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        loginUser(
                                            _scaffoldKey.currentContext,
                                            _inputEmail.text,
                                            _inputPassword.text);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color:
                                          Color.fromRGBO(235, 235, 235, 0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                                children:[
                                  Expanded(
                                      child: Divider(
                                        thickness: 0.5,
                                        color: Colors.grey[400],
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                          "Or continue with",
                                          style: TextStyle(color: Colors.grey[400])
                                      )
                                  ),
                                  Expanded(
                                      child: Divider(
                                        thickness: 0.5,
                                        color: Colors.grey[400],
                                      )
                                  ),
                                ]
                            ),
                            SizedBox(height: 20),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                height: 70,
                                width: 70,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Image.asset('lib/assets/images/services/service_google.png'),
                                    onPressed: () => AuthService().signInWithGoogle(),
                                  ),
                                )
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupPage()));
                              },
                              child: const Text(
                                'Sign up instead',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    )

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

  _verifyPassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  loginUser(context, email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = "Sorry, that email or password is incorrect.";
          break;
        case 'invalid-email':
          errorMessage = "Please enter a valid email address.";
          break;
        default:
          errorMessage = "Authentication failed. Please try again later.";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }
  }
}
