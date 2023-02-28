part of main;

class ProfilePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inputTitle = TextEditingController();
  final _inputContent = TextEditingController();
  final _inputTSActivityStartDate = TextEditingController();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28)),
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          controller: _inputTitle,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                            hintText: 'Enter title',
                          ),
                          validator: (String? value) {
                            return _verifyTitle(value);
                          },
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _inputContent,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Content',
                            hintText: 'Enter additional information here.',
                          ),
                          validator: (String? value) {
                            return _verifyContent(value);
                          },
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          controller: _inputTSActivityStartDate,
                          readOnly: true,
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                onConfirm: (date) {
                                  String formattedDate = DateFormat('EEEE, MMMM d, y').format(date);
                                  _inputTSActivityStartDate.text = formattedDate;
                                }, locale: LocaleType.en);
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                          ),
                          validator: (String? value) {
                            return _verifyDate(value);
                          },
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var author = await _getAuthor();
                                  _writePost(context, _inputTitle.text, _inputContent.text, author["userID"], author["username"]);
                                }
                              },
                              child: const Text('Write Data'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _logoutUser(context);
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                )
            )
        )
    );
  }

  _verifyTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  _verifyDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a start date';
    }
    return null;
  }

  _verifyContent(String? value) {
    return null;
  }

  void _logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error logging out your account. Please try again later."),
      ));
      return;
    }
  }

  void _writePost(BuildContext context, title, content, userID, username) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");
      ref.push().update({
        'title': title,
        'content': content,
        'userID': userID,
        'username': username,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Post has been submitted!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error submitting your post. Please try again later."),
      ));
    }
  }
  _getAuthor() async {
    String userID = '';
    String username = 'Anonymous';
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userID = user.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userID/username");
      DataSnapshot snapshot = await ref.get();
      username = snapshot.value.toString();
    }
    return {"userID": userID, "username": username};
  }
}